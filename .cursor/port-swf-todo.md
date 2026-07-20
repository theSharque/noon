# SWF → Svelte: очередь портирования

Файлы `www/swf/*.jpg` — это **SWF** (Flash), не растровые JPEG.  
ActionScript-источники: `old_data/*3.as`.  
SPA: `frontend/src/`, маршруты — `frontend/src/lib/router.js`.

Дизайн: **Cosmic UI** (ветка `redisign`) — [`frontend/docs/Cosmic_UI_Design_System.md`](../frontend/docs/Cosmic_UI_Design_System.md).  
Статусы: **done** | **redesign** | **partial** | **stub** | **todo**

---

## Сводка

| Статус | Кол-во |
|--------|--------|
| redesign (cosmic UI) | shell + booklist + about + misc |
| stub | 4 — place, ships, ware, trade |
| todo | transitions, tutorial |

---

## Cosmic redesign (2026-07-20, ветка `redisign`)

- Design system: `frontend/docs/Cosmic_UI_Design_System.md`
- Концепты: `frontend/public/img/design/cosmic-concept-{1,2}.png`
- Токены/utilities: `frontend/src/app.css`
- UI kit: `frontend/src/lib/ui/` (ScifiPanel, ScifiButton, ScifiTabs, ProgressBar, StatRow)
- Shell: `App.svelte`, `TopMenu.svelte`, `Chat.svelte` — glass/cyan, без sprite-кнопок
- `Booklist.svelte` / `About.svelte` / `Misc.svelte` — CSS grid, без absolute 1000×500 и PNG-скинов; RPC без изменений
- Pixel-perfect purge (booklist / about / topmenu / fonts): **done** 2026-07-20

### Pixel-perfect purge list

| Путь | Статус |
|------|--------|
| `frontend/public/img/booklist/` (кроме `sounds/`) | **удалено** |
| `frontend/public/img/about/` (кроме `buzz.mp3`) | **удалено** |
| `frontend/public/img/topmenu/*.png`, `plate.svg` | **удалено** (оставлены `*.wav` + `*.mp3`) |
| `frontend/public/fonts/*Techno*`, `*Terminator*` | **удалено** |
| `www/swf/{read,write,booklist}.jpg` | **удалено** (отдельно от SPA-purge; about.jpg ещё есть) |

Проверка: `rg -n "img/booklist|img/about|Techno|TerminatorCyr" frontend/src` — только `const IMG` для sounds.

---

## Оболочка клиента

| SWF | SPA | Статус | Заметки |
|-----|-----|--------|---------|
| `topmenu.jpg` | `TopMenu.svelte` | **redesign** | Cosmic nav; SFX wav; SWF удалён ранее |
| `read.jpg` / `write.jpg` | `Chat.svelte` | **redesign** | Glass chat; SWF удалён |

---

## Основные игровые экраны

| SWF | SPA | Статус | Заметки |
|-----|-----|--------|---------|
| `booklist.jpg` | `/character`, `/mail` → `Booklist.svelte` | **redesign** | 5 вкладок, cosmic grid; SWF удалён |
| `about.jpg` | `/about` → `About.svelte` | **redesign** | Профиль/медали; PNG purged; SWF ещё в www |
| `planet/orbit/station` | `/place` | **stub** | |
| `ships.jpg` | `/ships` | **stub** | |
| `warehouse.jpg` | `/ware` | **stub** | |
| `trade.jpg` | `/trade` | **stub** | Следующий кандидат на cosmic (concept-2) |
| `misc.jpg` | `/misc` → `Misc.svelte` | **redesign** | 7 вкладок + atlas SVG; SWF ещё в www |

---

## Переходы / прочее

| Файл | Статус |
|------|--------|
| land/flyout/infly/inhyper/inspace | **todo** |
| tutorial.jpg | **todo** |

---

## Удалено из `www/swf/` (журнал)

| Файл | Дата / коммит | Замена |
|------|---------------|--------|
| `topmenu.jpg` | `0b4a05d` Fix menu and chat | `frontend/src/lib/TopMenu.svelte` |
| `read.jpg` / `write.jpg` | 2026-07-20 cosmic purge | `frontend/src/lib/Chat.svelte` |
| `booklist.jpg` | 2026-07-20 cosmic purge | `frontend/src/routes/Booklist.svelte` |
