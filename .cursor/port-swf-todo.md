# SWF → Svelte: очередь портирования

Файлы `www/swf/*.jpg` — это **SWF** (Flash), не растровые JPEG.  
ActionScript-источники: `old_data/*3.as`.  
SPA: `frontend/src/`, маршруты — `frontend/src/lib/router.js`.

Статусы: **done** | **partial** | **stub** | **todo**

---

## Сводка

| Статус | Кол-во |
|--------|--------|
| partial (SWF удалён) | 1 — topmenu |
| partial (SWF ещё в www) | 5 — chat read+write, mail, about, booklist |
| stub | 5 |
| todo | 1+ |

---

## booklist — проверка (2026-07-20)

- `frontend/src/routes/Booklist.svelte` — единый экран 1000×500, `/character` и `/mail` (query `tab=`, `sp=2`, `msgto=`).
- Ассеты: `frontend/public/img/booklist/`, шрифты `99_Techno.ttf`, `133_TerminatorCyr.ttf`, звуки scratch/buzz.
- API: `frontend/src/lib/api.js` — id 8, 11–17, 122–124, 131–134, 151 + mail 125–129.
- Сборка: `npm run build`, деплой в `www/app/`; ассеты и RPC проверены curl (test/test).
- SWF `www/swf/booklist.jpg` **не удалён**; `page.php?id=1` по-прежнему SWF.
- Визуальный overlay/diff с `frames/1.png` — ожидает ручного browser-check после логина.

---

## Оболочка клиента (отдельные SWF, frameset)

В старом клиенте три независимых Flash-модуля в одном окне:

```
┌─ topmenu.jpg  (22px) ─────────────────────────┐
├─ main frame: planet/ships/… *.jpg  (500px) ───┤
├─ read.jpg  (чат, чтение) ─────────────────────┤
└─ write.jpg (чат, ввод) ───────────────────────┘
```

| SWF | AS | Было | SPA | Статус | Заметки |
|-----|-----|------|-----|--------|---------|
| `topmenu.jpg` | `topmenu3.as` | `www/pages/topmenu.page` | `TopMenu.svelte` | **partial** | SWF **удалён** (коммит `0b4a05d`); логика (nav, music, ping, mail) перенесена; визуал на SVG/PNG, не 1:1 |
| `read.jpg` | `read3.as` | `pages/chat/read.page`, `reader.php` | `Chat.svelte` (верх) | **partial** | SWF **ещё в** `www/swf/`; SPA заменяет в `shell.page`, legacy embed остался |
| `write.jpg` | `write3.as` | `pages/chat/write.page` | `Chat.svelte` (низ) | **partial** | SWF **ещё в** `www/swf/`; то же |

Экспорт ffdec: `old_data/topmenu_export/` (topmenu), `read.jpg`/`write.jpg` — распаковать по `/portSwf`.

---

## Основные игровые экраны (`render_page`)

| SWF | AS | SPA | Статус | Компонент / заметки |
|-----|-----|-----|--------|---------------------|
| `booklist.jpg` | `books3.as` | `/character`, `/mail` | **partial** | `Booklist.svelte` — pixel-perfect 1000×500, 5 вкладок, левая панель, modals, hints, SFX; API 8/11-17/122-134/151 + mail 125-129; SWF **ещё в** `www/swf/` до подтверждения; `id=1` не переключён |
| `planet.jpg` | `planet3.as` | `/place` | **stub** | Карта планеты, постройки, панель управления |
| `orbit.jpg` | `orbit3.as` | `/place` | **stub** | Орбита, точки стояния |
| `station.jpg` | `station3.as` | `/place` | **stub** | Торговая станция, сделки на месте |
| `ships.jpg` | `ships3.as` | `/ships` | **stub** | Список кораблей, приказы, карта системы/галактики |
| `warehouse.jpg` | `warehouse3.as` | `/ware` | **stub** | Перемещение грузов |
| `trade.jpg` | `trade3.as` | `/trade` | **stub** | Торговый компьютер, покупка/продажа, конфедерация |
| `misc.jpg` | `misc3.as` | `/misc` | **stub** | Энциклопедия, роботы, настройки, альянс |
| `about.jpg` | `about3.as` | `/about` | **partial** | `About.svelte` — pixel-perfect 1000×500 по XFL: профиль, медали, отношения, glow/modal/SFX; SWF **ещё в** `www/swf/` до подтверждения; `id=18` → SPA boot |

### Вкладки внутри `booklist.jpg` (один SWF, несколько UI)

| Вкладка | Элементы SWF | SPA | Статус |
|---------|--------------|-----|--------|
| СООБЩЕНИЯ | `dgListMsg`, `dtTextMsg`, `pSend` | `/mail`, `/character` | **partial** |
| ОБУЧЕНИЕ | `dgListLrn`, обучение/импланты | `/character` | **partial** |
| ЗАДАНИЯ | `dgListQst`, квесты | `/character` | **partial** |
| СТАТИСТИКА | `dgList`, владения | `/character` | **partial** |
| ОТНОШЕНИЯ | друзья/враги/игнор | `/character` | **partial** |
| Левая панель | `movLeftSide` (звезда, кредиты, статусы) | `/character` | **partial** |

---

## Переходы / заставки (`place.page`)

| SWF | Назначение | Статус | Заметки |
|-----|------------|--------|---------|
| `land.jpg` | посадка на планету | **todo** | Короткая анимация |
| `flyout.jpg` | взлёт с планеты | **todo** | |
| `infly.jpg` | полёт в системе | **todo** | |
| `inhyper.jpg` | гиперпереход | **todo** | |
| `inspace.jpg` | открытый космос | **todo** | |
| `indeep` | глубокий космос | **todo** | Вызывается в `place.page`, файла нет в `www/swf/` |

---

## Прочее

| Файл | Назначение | Статус | Заметки |
|------|------------|--------|---------|
| `tutorial.jpg` | оверлей обучения | **todo** | `include/tutorial.inc`, `show_tutorial()` |
| `deepspace.swf` | глубокий космос (альт.) | **todo** | `pages/environment/deepspace.page`; файла нет в `www/swf/` |

---

## Рекомендуемый порядок портирования

1. **mail** (`booklist` / СООБЩЕНИЯ) — довести UI до SWF, затем удалить зависимость от `booklist` для почты
2. **character** (остальные вкладки `booklist` + левая панель)
3. **place** — `planet` → `orbit` → `station`
4. **ships**
5. **ware** → **trade**
6. **misc** + **about**
7. **chat** — довести UI до SWF (`read`+`write`), удалить `read.jpg`/`write.jpg` и `chat/read.page`/`write.page`
8. **transitions** (`land`, `infly`, …) — по желанию
9. **tutorial**

---

## Удалено из `www/swf/` (журнал)

| Файл | Дата / коммит | Замена |
|------|---------------|--------|
| `topmenu.jpg` | `0b4a05d` Fix menu and chat | `frontend/src/lib/TopMenu.svelte` |
