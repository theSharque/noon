Порт одного SWF-экрана в Svelte SPA в стиле **Cosmic UI** (ветка `redisign`).

**Аргумент:** `$ARGUMENTS` — имя SWF из `www/swf/`, например `trade.jpg`, `ships.jpg`, `planet.jpg`.

Работай **только** с этим экраном от шага 0 до конца. Не переключайся на другие SWF.

---

## Главное правило

**Визуал = Cosmic UI. Поведение = Flash/PHP.**

| Слой | Источник истины |
|------|-----------------|
| RPC, state, видимость кнопок, звуки, навигация | ActionScript (`old_data/*3.as` / ffdec scripts) + `www/pages/**` |
| Цвета, панели, кнопки, шрифты, layout | [`frontend/docs/Cosmic_UI_Design_System.md`](../../frontend/docs/Cosmic_UI_Design_System.md), токены `app.css`, kit `frontend/src/lib/ui/` |
| Эталон атмосферы | `frontend/public/img/design/cosmic-concept-{1,2}.png` |

**Запрещено:**

- pixel-perfect absolute 1000×500 и PNG-скины кнопок/панелей;
- копировать Techno/Terminator / Flash-шрифты в новую вёрстку;
- нативный «серый» UI или чужой дизайн-язык;
- менять PHP/контракт RPC без необходимости;
- «угадывать» бизнес-правила (пример: `checkto` красный для `id < 15` — так и должно быть).

Концепты = **язык дизайна**, не дословные экраны trade/radar.

---

## 0. Разбор аргумента

```bash
SWF=<имя из $ARGUMENTS, без .jpg>
SWF_PATH=www/swf/${SWF}.jpg
OUT=old_data/ffdec_export/$SWF
AS=old_data/${SWF}3.as   # или ближайший *3.as / $OUT/scripts/
```

- Нормализуй имя: убери путь, добавь `.jpg` если нет.
- Если SWF уже удалён — `git show` / готовый `$OUT` / AS из `old_data/`.
- Сверь маршрут SPA: `frontend/src/lib/router.js` + статус в `.cursor/port-swf-todo.md`.
- Найди PHP: `grep` / `page.php` case / `render_page` / embed.

---

## 1. Поведение из Flash (обязательно до кода)

Экспорт AS нужен для **логики**, не для пикселей.

### 1.1 AS / ffdec (по необходимости)

Если AS уже есть в `old_data/` — можно без полного реэкспорта. Иначе:

```bash
mkdir -p "$OUT"
java -jar old_data/ffdec/ffdec.jar -export script "$OUT" "$SWF_PATH"
```

XML/PNG/fonts **не** требуются для Cosmic-порта (это был pixel-perfect пайплайн).

### 1.2 Выпиши из AS → план

- начальные RPC (`page.php?id=…`, порядок вызовов);
- вкладки / режимы экрана;
- видимость контролов (`visible = false` и условия);
- действия кнопок и модалки;
- звуки (если есть — оставить SFX path, без PNG);
- навигация (`navigateToURL` → `push()` / query);
- обработка `err != 0` (glow fail/ok и т.п.).

PHP **не менять**, если контракт совпадает. Ошибки валидации (красный glow) сохранять как в бэке.

---

## 2. Cosmic layout (не Flash geometry)

Используй существующий kit:

| Компонент | Файл |
|-----------|------|
| Панель | `ScifiPanel.svelte` |
| Кнопка | `ScifiButton.svelte` (`primary` / `ghost` / `warn` / `danger`) |
| Вкладки | `ScifiTabs.svelte` |
| Таблица | `.scifi-table` + `.active-row` |
| Статы | `StatRow.svelte` |
| Прогресс | `ProgressBar.svelte` |
| Токены | `frontend/src/app.css` |

Типовой паттерн (как Booklist после уточнения):

```
[ ScifiTabs ]
┌──────────────┬─────────────────────────────┐
│ Левая колонка│ Сверху: список / таблица    │
│ (статус/навиг│ Снизу: деталь + CTA         │
└──────────────┴─────────────────────────────┘
```

Правила вёрстки:

- CSS **grid/flex**, адаптив; breakpoint stack ~`500px` (как shell/booklist);
- текст кнопок, не PNG;
- selected-row: cyan capsule + лёгкий glow (полосы на стыках ячеек допустимы);
- HTML из PHP (`<font color>`, chat users) — **не** перекрашивать все ссылки в cyan; `color: inherit` где нужно;
- SFX оставить по желанию (`sounds/`, `*.wav`).

Эталоны реализации: `Booklist.svelte`, `About.svelte`, `TopMenu.svelte`, `Chat.svelte`.

---

## 3. План экрана (согласование)

Покажи пользователю **до кода**:

1. SWF / AS / текущий stub-route
2. Схема блоков Cosmic (не координаты Flash)
3. Список RPC и сценариев (load / select / action / error)
4. Файлы: route, `api.js`, router, todo
5. Что вне scope
6. Browser-check сценарий
7. Что удалить после приёмки (`www/swf/…`, временные PNG если появятся)

Жди **«ок»**. Код не писать до подтверждения.

---

## 4. Реализация

- Один route (или явно оговорённые части) на Cosmic kit
- Обёртки API в `frontend/src/lib/api.js` по AS
- Не тащить Flash PNG/fonts в `public/`
- `npm run build`
- Синхрон в Docker-отдачу:

```bash
rsync -a --delete frontend/dist/ www/app/
docker compose up -d --build php nginx
```

(образ **копирует** `www/` — правки PHP на хосте без rebuild/cp в контейнер не попадут)

- Обновить `.cursor/port-swf-todo.md` → статус **redesign**
- MCP architect (`html-client` / модуль экрана) при существенных изменениях
- **Коммит не создавать** без явной просьбы

---

## 5. Проверка (@Browser)

1. `http://127.0.0.1:3080/` (порт из `.env` `NGINX_PORT`) — login test/test при необходимости
2. Сценарии из плана: загрузка, выбор строки, CTA, ошибка валидации, query-params (`?to=`, `?login=`)
3. Скриншот: панели/glow/кнопки читаемы; detail+actions не обрезаны чатом
4. Отчёт: что ок / что нет

---

## 6. Purge после приёмки

**Только после явного согласия пользователя.**

1. Удалить `www/swf/<имя>.jpg` (+ мёртвые embed/`render_page`, если есть)
2. Не удалять `old_data/`, чужие SWF, PHP RPC pages
3. Не удалять SFX, если экран их использует
4. Журнал в `.cursor/port-swf-todo.md` («Удалено из www/swf/»)

Проверка «ничего Flash-визуала не осталось» для этого экрана:

```bash
rg -n "img/${SWF}|swf/${SWF}" frontend/src www
```

---

## Антипаттерны

| Не делать | Делать |
|-----------|--------|
| Absolute PNG-скины 1:1 Flash | Cosmic `ScifiPanel` / grid |
| Techno/Terminator на весь UI | Exo 2 / токены `--font-ui` |
| Менять `checkto`/RPC «чтобы зеленело» | Сохранять правила бэка |
| Забыть sync `www/app` + rebuild php/nginx | Всегда деплоить после UI/PHP |
| Pixel-perfect diff с `frames/1.png` | Сверка с concept + UX сценариями |
| Три колонки «как в старом booklist-плане» | Актуальный layout экрана (уточнять у пользователя) |

---

## Чеклист

- [ ] AS/PHP: RPC и поведение разобраны
- [ ] План Cosmic-layout согласован («ок»)
- [ ] Реализация на UI kit + `api.js`
- [ ] `npm run build` + sync `www/app` + rebuild php/nginx
- [ ] Browser check сценариев
- [ ] `port-swf-todo.md` → **redesign**
- [ ] Architect обновлён (если нужно)
- [ ] SWF/purge удалён (если пользователь сказал ок)
