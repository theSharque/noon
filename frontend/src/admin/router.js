import Dashboard from './screens/Dashboard.svelte';
import Users from './screens/Users.svelte';
import FullLog from './screens/FullLog.svelte';
import Stats from './screens/Stats.svelte';
import Objects from './screens/Objects.svelte';
import Recipes from './screens/Recipes.svelte';
import Encyclopedia from './screens/Encyclopedia.svelte';
import Research from './screens/Research.svelte';
import ShipTypes from './screens/ShipTypes.svelte';
import Tutorials from './screens/Tutorials.svelte';

export const routes = {
  '/': Dashboard,
  '/users': Users,
  '/users/:login': Users,
  '/log': FullLog,
  '/stats': Stats,
  '/objects': Objects,
  '/recipes': Recipes,
  '/encyclopedia': Encyclopedia,
  '/research': Research,
  '/ships': ShipTypes,
  '/tutorials': Tutorials,
};

export const nav = [
  {
    title: 'Игроки',
    items: [
      { href: '#/users', label: 'Пользователи', path: '/users' },
      { href: '#/log', label: 'Activity log', path: '/log' },
    ],
  },
  {
    title: 'Экономика',
    items: [
      { href: '#/', label: 'Dashboard', path: '/' },
      { href: '#/stats', label: 'Статистика', path: '/stats' },
    ],
  },
  {
    title: 'Каталог',
    items: [
      { href: '#/objects', label: 'Объекты', path: '/objects' },
      { href: '#/recipes', label: 'Рецепты', path: '/recipes' },
      { href: '#/encyclopedia', label: 'Энциклопедия', path: '/encyclopedia' },
      { href: '#/research', label: 'Исследования', path: '/research' },
    ],
  },
  {
    title: 'Корабли',
    items: [{ href: '#/ships', label: 'Типы кораблей', path: '/ships' }],
  },
  {
    title: 'Контент',
    items: [{ href: '#/tutorials', label: 'Обучалка', path: '/tutorials' }],
  },
];
