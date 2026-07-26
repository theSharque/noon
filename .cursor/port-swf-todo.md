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
| redesign (cosmic UI) | shell + booklist + about + misc + ware + trade + ships + place(planet+orbit+station) + tutorial + infly/inhyper/inspace/indeep/land/takeoff |
| stub | — |
| todo | battle Cosmic animation (Ships) |

---

## Cosmic redesign (2026-07-20, ветка `redisign`)

- Design system: `frontend/docs/Cosmic_UI_Design_System.md`
- Концепты: `frontend/public/img/design/cosmic-concept-{1,2}.png`
- Токены/utilities: `frontend/src/app.css`
- UI kit: `frontend/src/lib/ui/` (ScifiPanel, ScifiButton, ScifiTabs, ProgressBar, StatRow, PlanetMap, OrbitMap, GalaxyMap, PlaceControlPanel)
- Shell: `App.svelte`, `TopMenu.svelte`, `Chat.svelte` — glass/cyan, без sprite-кнопок
- `Booklist.svelte` / `About.svelte` / `Misc.svelte` / `Warehouse.svelte` / `Trade.svelte` — CSS grid, без absolute 1000×500 и PNG-скинов; RPC без изменений
- Pixel-perfect purge (booklist / about / topmenu / fonts): **done** 2026-07-20
- Routes: Booklist, About, Misc, Warehouse, Trade, Ships, Place → Planet/Orbit/Station + transitions

### Pixel-perfect purge list

| Путь | Статус |
|------|--------|
| `frontend/public/img/booklist/` (кроме `sounds/`) | **удалено** |
| `frontend/public/img/about/` (кроме `buzz.mp3`) | **удалено** |
| `frontend/public/img/topmenu/*.png`, `plate.svg` | **удалено** (оставлены `*.wav` + `*.mp3`) |
| `frontend/public/fonts/*Techno*`, `*Terminator*` | **удалено** |
| `www/swf/{read,write,booklist,warehouse,trade,ships,about,misc}.jpg` | **удалено** |

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
| `about.jpg` | `/about` → `About.svelte` | **redesign** | Профиль/медали; PNG purged; SWF удалён |
| `planet.jpg` / `orbit.jpg` / `station.jpg` | `/place` → `Place` + `Planet` / `Orbit` / `Station` | **redesign** | Probe 21→22→233; planet hex map; orbit 1D strip + `p{pid}` bg; shared PlaceControlPanel; station trade; **SWF purged** |
| `ships.jpg` | `/ships` → `Ships.svelte` | **redesign** | Master–detail; galaxy 9/41; system map 8; war text poll; SWF удалён |
| `warehouse.jpg` | `/ware` → `Warehouse.svelte` | **redesign** | Dual-pane cargo move; RPC 41–47; SWF удалён |
| `trade.jpg` | `/trade` → `Trade.svelte` | **redesign** | 4 вкладки Comp/Bay/Sell/Conf; RPC 53–58, 63, 65, 651–652; SWF удалён |
| `misc.jpg` | `/misc` → `Misc.svelte` | **redesign** | 7 вкладок + atlas SVG; SWF удалён |

### Place — transitions

- `infly` — **redesign** (Canvas 2D); SWF purged 2026-07-26
- `inhyper` — **redesign** (Canvas 2D); SWF purged 2026-07-26
- `inspace` — **redesign** (Canvas 2D ambient pt=7); SWF purged 2026-07-26
- `indeep` — **redesign** (Canvas 2D ambient pt=8); SWF не было (новый экран)
- `land` — **redesign** (Canvas 2D descent by ptype; gettimer +ptype/pname; demo `?demo=land&ptype=1|3|4`); SWF purged 2026-07-26
- `takeoff` (ex-`flyout`) — **redesign** (Canvas 2D ascent FPV; et 1/101; demo `?demo=takeoff&ptype=1|3|4`); SWF flyout purged 2026-07-26

### Ships — отложено

- Полноценная Cosmic-анимация боя (пока упрощённый текстовый poll `361`/`362`) — отдельный большой проход

---

## Переходы / прочее

| Файл | Статус |
|------|--------|
| infly | **redesign** — `Infly.svelte` + `inflyFx.js`; gettimer id=240 (+et/st/sname); SWF purged |
| inhyper | **redesign** — `Inhyper.svelte` + `inhyperFx.js`; et 4/5/104/105; SWF purged |
| inspace | **redesign** — `Inspace.svelte` + `inspaceFx.js`; pt=7; SWF purged |
| indeep | **redesign** — `Indeep.svelte` + `indeepFx.js`; pt=8; indeep-bg |
| land | **redesign** — `Land.svelte` + `landFx.js`; et 0/100 + spy 6 / sabotage 8; SWF purged |
| takeoff (ex-flyout) | **redesign** — `Takeoff.svelte` + `takeoffFx.js`; et 1/101; SWF flyout purged |
| tutorial.jpg | **done** — `Tutorial.svelte` overlay, RPC id=14 (`gettutor.page`); SWF + `tutorial.inc` purged 2026-07-25 |

---

## Удалено из `www/swf/` (журнал)

| Файл | Дата / коммит | Замена |
|------|---------------|--------|
| `topmenu.jpg` | `0b4a05d` Fix menu and chat | `frontend/src/lib/TopMenu.svelte` |
| `read.jpg` / `write.jpg` | 2026-07-20 cosmic purge | `frontend/src/lib/Chat.svelte` |
| `booklist.jpg` | 2026-07-20 cosmic purge | `frontend/src/routes/Booklist.svelte` |
| `warehouse.jpg` | 2026-07-21 cosmic port | `frontend/src/routes/Warehouse.svelte` |
| `trade.jpg` | 2026-07-21 cosmic port | `frontend/src/routes/Trade.svelte` |
| `ships.jpg` | 2026-07-22 cosmic accept | `frontend/src/routes/Ships.svelte` |
| `about.jpg` | 2026-07-22 cosmic accept | `frontend/src/routes/About.svelte` |
| `misc.jpg` | 2026-07-22 cosmic accept | `frontend/src/routes/Misc.svelte` |
| `orbit.jpg` | 2026-07-25 cosmic accept | `frontend/src/routes/Orbit.svelte` |
| `tutorial.jpg` | 2026-07-25 cosmic accept | `frontend/src/lib/Tutorial.svelte` (+ RPC `gettutor.page`) |
| `planet.jpg` | 2026-07-25 cosmic accept | `frontend/src/routes/Planet.svelte` |
| `station.jpg` | 2026-07-25 cosmic accept | `frontend/src/routes/Station.svelte` |
| `infly.jpg` | 2026-07-26 cosmic accept | `frontend/src/routes/Infly.svelte` + `inflyFx.js` |
| `inhyper.jpg` | 2026-07-26 cosmic accept | `frontend/src/routes/Inhyper.svelte` + `inhyperFx.js` |
| `inspace.jpg` | 2026-07-26 cosmic accept | `frontend/src/routes/Inspace.svelte` + `inspaceFx.js` |
| `land.jpg` | 2026-07-26 cosmic accept | `frontend/src/routes/Land.svelte` + `landFx.js` |
| `flyout.jpg` | 2026-07-26 cosmic accept | `frontend/src/routes/Takeoff.svelte` + `takeoffFx.js` |
