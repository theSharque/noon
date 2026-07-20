Порт одного SWF-экрана в Svelte SPA **pixel-perfect, 1:1 с Flash**.

**Аргумент:** `$ARGUMENTS` — имя SWF из `www/swf/`, например `planet.jpg`, `ships.jpg`, `about.jpg`.

Работай **только** с этим SWF от шага 1 до конца. Не переключайся на другие экраны.

---

## Главное правило

**Не переносить «по ощущениям».** Не угадывать шрифты, размеры, цвета, позиции и кнопки по скриншоту или по тому, что «похоже на topmenu».

Источник истины — **бинарный SWF** + **ActionScript** + **ffdec export**. Скриншот (`frames/1.png`) — только для финальной сверки, не для проектирования.

Если поле не разобрано в таблице стилей (шаг 1.4) — **CSS для него не писать**.

---

## 0. Разбор аргумента

```bash
SWF=<имя из $ARGUMENTS, без .jpg>
SWF_PATH=www/swf/${SWF}.jpg
OUT=old_data/ffdec_export/$SWF
```

- Нормализуй имя: убери путь, добавь `.jpg` если нет.
- Если файла нет в `www/swf/` — `git show HEAD^:www/swf/${SWF}.jpg` или уже готовый `$OUT`.
- AS: `old_data/*3.as` и/или `$OUT/scripts/*.as` — найди главный класс (`planet3`, `about3`, …).

---

## 1. ffdec export + машиночитаемый разбор (обязательно до кода)

### 1.1 Полный экспорт

```bash
rm -rf "$OUT" && mkdir -p "$OUT"
java -jar old_data/ffdec/ffdec.jar \
  -export script,image,sprite,button,shape,symbolClass,frame,font,text \
  "$OUT" "$SWF_PATH"
```

Дополнительно — **XML всего SWF** (для координат, шрифтов, цветов, фильтров):

```bash
java -jar old_data/ffdec/ffdec-cli.jar -swf2xml "$SWF_PATH" /tmp/${SWF}_dump.xml
```

### 1.2 Что изучить в экспорте

| Источник | Для чего |
|----------|----------|
| `$OUT/frames/1.png` | финальная визуальная сверка |
| `$OUT/scripts/<main>.as` | RPC `page.php?id=…`, видимость, звуки, переходы |
| `$OUT/buttons/`, `$OUT/images/` | PNG-скины кнопок и панелей **в натуральном размере** |
| `$OUT/fonts/*.ttf` | встроенные шрифты SWF — **канонические копии** |
| `/tmp/${SWF}_dump.xml` | **точные** fontId, fontHeight, RGB, matrix, filters |

Сверь с PHP: `grep` по имени SWF в `www/` (`render_page`, embed, `page.php` case).

### 1.3 Геометрия холста

Из XML / PlaceObject2Tag / размеров root sprite:

- Зафиксируй **точный размер stage** (часто 1000×500; у topmenu — свой).
- Корневой контейнер Svelte: `position: relative; width: <W>px; height: <H>px; overflow: hidden`.
- **Все** элементы — `position: absolute` с координатами из SWF (twips ÷ 20 = px).
- **Запрещено:** flex/grid «на глаз», `width: 100%` на кнопках, растягивание PNG (`background-size: 100% 100%` на скинах), произвольное центрирование, внутренние отступы «для красоты».

Перед использованием PNG проверь **роль** символа в XML (пример ошибки: `frame-login.png` оказался рамкой модалки в `(200,130)`, а не полем логина).

### 1.4 Таблица стилей текста (обязательна в плане)

**Для каждого** `DefineTextTag` и `DefineEditTextTag` выпиши таблицу **до написания CSS**:

```bash
# Пример: список всех текстовых полей с fontId, размером и цветом
python3 << 'PY'
import re, pathlib
xml = pathlib.Path(f"/tmp/{SWF}_dump.xml").read_text(encoding="utf-8", errors="replace")
fonts = {m.group(1): m.group(2) for m in re.finditer(r'fontID="(\d+)"[^>]*fontName="([^"\\]+)', xml)}
for kind in ("DefineTextTag", "DefineEditTextTag"):
    for m in re.finditer(rf'<item type="{kind}" characterID="(\d+)"[^>]*>(.*?)</item>', xml, re.DOTALL):
        cid = m.group(1)
        block = m.group(0)
        fid = re.search(r'fontId="(\d+)"', block)
        fh = re.search(r'fontHeight="(\d+)"', block)
        col = re.search(r'<textColor type="RGB" blue="(\d+)" green="(\d+)" red="(\d+)"/>', block)
        txt = pathlib.Path(f"old_data/ffdec_export/{SWF}/texts/{cid}.txt")
        label = txt.read_text(encoding="utf-8", errors="replace").strip() if txt.exists() else "?"
        if not fid: continue
        fid = fid.group(1)
        size = int(fh.group(1)) / 20 if fh else "?"
        color = f"#{int(col.group(3)):02x}{int(col.group(2)):02x}{int(col.group(1)):02x}" if col else "?"
        print(f"{cid}\t{fonts.get(fid,'?')}\t{size}px\t{color}\t{label[:60]}")
PY
```

Правила интерпретации:

| SWF | CSS |
|-----|-----|
| `fontHeight="240"` | `12px` |
| `fontHeight="320"` | `16px` |
| `fontHeight="720"` | `36px` (проверь scale у родителя!) |
| `fontId` → `Techno` | `@font-face` из `$OUT/fonts/*Techno*.ttf` |
| `fontId` → `Terminator Cyr…` | из `old_data/topmenu_export/fonts/` или `$OUT/fonts/` |
| `fontId` → `Verdana` | `Verdana, sans-serif` (как в AS `TextFormat`) |
| RGB `#cccccc` | `color: #ccc` — **не** подменять на `#bfbfff` |

**Запрещено:**

- ставить `TerminatorCyr` на весь экран «потому что topmenu»;
- назначать шрифт по типу текста (заголовок/кнопка) без `fontId` из XML;
- использовать system font там, где в SWF embedded font;
- экспортировать WOFF «наугад» — брать **TTF из `$OUT/fonts/`** или `old_data/`.

В плане покажи таблицу пользователю. Если два поля выглядят похоже — это **не** повод дать им один CSS-класс без проверки `characterID`.

### 1.5 Шрифты в проекте

```bash
# Копировать канонические TTF (источник — old_data, не выдуманные пути)
cp "$OUT/fonts/"*.ttf frontend/public/fonts/   # или точечно по таблице
```

В Svelte:

```css
@font-face {
  font-family: 'NoonTechno';
  src: url('/app/fonts/96_Techno.ttf') format('truetype');
}
```

Имена семейств — стабильные (`NoonTechno`, `TerminatorCyr`). Путь в SPA: `/app/fonts/…`, `/app/img/<SWF>/…`.

### 1.6 Кнопки и интерактив

Из `$OUT/buttons/` и XML `DefineButton2Tag`:

- Кнопка = **PNG-скин** (`<img>`) в **натуральном размере**, не CSS-текст поверх градиента.
- Состояния: up / over / down — отдельные кадры или фильтры из SWF.
- Hover/active: воспроизвести `GLOWFILTER` / `BEVELFILTER` из XML (`drop-shadow`, `box-shadow`), не придумывать новый стиль.
- Подпись на кнопке чаще **вшита в PNG**; если есть `DefineTextTag` внутри кнопки — шрифт из таблицы 1.4, не Terminator по умолчанию.
- Звук клика: экспорт `$OUT/sounds/` → тот же `Sound`/`buzz`, что в AS.

**Запрещено:** `<button>Текст</button>` вместо скина; `<select>`; нативный scrollbar вместо `scroll-track.png` / `scroll-thumb.png`.

### 1.7 Цвета и эффекты

Из XML, не из памяти:

- `textColor` RGB → `color: #rrggbb`
- `GlowFilter` на логине/ошибке: outer `#0000ff`, inner `#00ffff` / `#ff0000` (как в AS)
- Фон stage, border DataGrid, alternating rows — из `$OUT/sprites/` и AS `setStyle`
- Opacity модалок и `Tween` — длительность/easing из AS (`Strong.easeOut`, ~1s)

### 1.8 Поведение (AS)

Из главного `.as` **до вёрстки** выпиши:

- начальные RPC (какой `id` первым — не угадывать);
- видимость контролов (`visible = false` при старте);
- взаимоисключения (ComboBox ↔ DataGrid);
- навигация: SPA-эквивалент `navigateToURL` / `page.php?id=…`;
- очистка полей при `err != 0`.

PHP **не менять**, если контракт уже совпадает.

---

## 2. План экрана (согласование)

Покажи пользователю **до кода**:

1. Эталон: `frames/1.png` + главный `.as`
2. Размер stage и схема слоёв (координаты ключевых блоков)
3. **Таблица стилей текста** (шаг 1.4) — font, size, color, characterID
4. Список PNG-скинов и их координаты
5. API (`page.php?id=…`) и сценарии состояний
6. Файлы Svelte / router / api
7. Что вне scope
8. Сценарий browser-check

Жди **«ок»**. Код не писать до подтверждения.

---

## 3. Реализация

- Один route-компонент (или явно оговорённые части) с **абсолютной SWF-геометрией**
- Константы координат — из XML, с комментарием `characterID` / имени инстанса AS где возможно
- Стили текста — **строго по таблице 1.4**, отдельный CSS-класс на группу полей с одинаковым `fontId+fontHeight+color`
- Ассеты: `frontend/public/img/<SWF>/` — копии из `$OUT`
- Шрифты: `frontend/public/fonts/` — из `$OUT/fonts/` или `old_data/`
- API: обёртки в `frontend/src/lib/api.js` по AS
- `old_data/` не перезаписывать без нужды (экспорт — в `$OUT`)
- `npm run build`
- `cp -a frontend/dist/. www/app/` (локально) + при Docker `docker compose up -d --build nginx`
- Обновить `.cursor/port-swf-todo.md`
- MCP architect — при существенных изменениях

**Антипаттерны (повтор About — больше не допускать):**

| Было неправильно | Как надо |
|------------------|----------|
| Terminator на все подписи | Techno 16px `#ccc` на stat labels (по `fontId=96`) |
| `frame-login.png` как input логина | Правильный skin + координаты из XML |
| Модалка 520×280 вместо 1000×500 | Full-stage overlay как в SWF |
| Native `<select>` | ComboBox skins из export |
| 11 строк на всю ширину | Двухколоночная геометрия из PlaceObject |
| Шрифт «похож на Verdana» | `fontId` из XML |

---

## 4. Проверка (@Browser)

1. Логин → сценарии из плана (загрузка, ошибка, все кнопки)
2. Viewport = размер stage; overlay/diff с `frames/1.png`
3. DevTools → **Computed font** на каждом типе поля (логин, labels, values, grid, modal)
4. Отчёт: что совпало / что нет

---

## 5. Удаление SWF из www

**Только после проверки и явного согласия пользователя.**

Удалить `www/swf/<имя>.jpg`, убрать мёртвые `render_page`/embed.  
**Не удалять** `old_data/` и чужие SWF.  
**Коммит не создавать** без явной просьбы.

---

## Чеклист (все пункты обязательны)

- [ ] ffdec export + `-swf2xml` для `$ARGUMENTS`
- [ ] Таблица стилей текста (fontId, size, color) в плане
- [ ] Координаты и размер stage из XML
- [ ] PNG-скины кнопок/панелей в натуральном размере
- [ ] TTF из `$OUT/fonts/` подключены
- [ ] План согласован
- [ ] Реализация + `npm run build`
- [ ] Browser check + сверка шрифтов в DevTools
- [ ] `port-swf-todo.md` обновлён
- [ ] SWF удалён (если пользователь сказал ок)
