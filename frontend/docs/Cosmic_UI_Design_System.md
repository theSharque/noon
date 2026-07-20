# Cosmic UI Design System — Полдень 21 века

Ветка `redisign`. Визуальный язык для Svelte SPA: holographic / glass panels на deep space.

## Эталоны

| Файл | Фокус |
|------|--------|
| `/app/img/design/cosmic-concept-1.png` | Tabs + 3 колонки: статус \| таблица \| описание |
| `/app/img/design/cosmic-concept-2.png` | Плотный dashboard: inputs, мини-графики, dual CTA |

Концепты = **язык дизайна**, не дословные экраны. Booklist сохраняет вкладки Сообщения / Обучение / Задания / Статистика / Отношения.

## Токены (CSS variables в `app.css`)

```css
--bg-deep, --bg-nebula
--panel-bg, --panel-bg-strong
--neon-cyan, --neon-cyan-glow, --border-light, --border-active
--text-main, --text-muted
--accent-buy, --accent-sell, --accent-warn, --accent-danger
--font-ui, --font-mono
--radius-panel, --glow-soft, --glow-strong
```

## Компоненты

| Класс / Svelte | Назначение |
|----------------|------------|
| `.scifi-panel` / `ScifiPanel.svelte` | Glass-панель с header и уголками |
| `.scifi-btn` / `ScifiButton.svelte` | CTA: primary / ghost / warn |
| `.scifi-tabs` / `ScifiTabs.svelte` | Вкладки |
| `.scifi-table` | Таблицы данных, `.active-row` |
| `.progress-*` / `ProgressBar.svelte` | Индикаторы |
| `StatRow.svelte` | Иконка + label + value |

## Layout Booklist

```
[ ScifiTabs ]
┌─────────────┬──────────────────────┬─────────────────┐
│ Статус      │ Таблица / список     │ Описание + CTA  │
│ командира   │                      │                 │
└─────────────┴──────────────────────┴─────────────────┘
```

## Правила для Cursor

1. Стили через CSS-переменные из `app.css`, не хардкод цветов.
2. Не использовать PNG-скины из `img/booklist/` и `img/about/` в новой разметке.
3. Логику RPC (`api.js`) не менять без необходимости.
4. Иконки — inline SVG.

## Pixel-perfect purge (после приёмки)

Удалить каталоги: `frontend/public/img/booklist/` (кроме sounds), `frontend/public/img/about/` (кроме buzz), Flash-шрифты Techno/Terminator.

Проверка:

```bash
rg -n "img/booklist|img/about|Techno|TerminatorCyr" frontend/src
```
