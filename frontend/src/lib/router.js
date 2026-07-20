import Stub from '../routes/Stub.svelte';
import Booklist from '../routes/Booklist.svelte';
import About from '../routes/About.svelte';
import Misc from '../routes/Misc.svelte';

export const routes = {
  '/character': Booklist,
  '/place': Stub,
  '/ships': Stub,
  '/ware': Stub,
  '/trade': Stub,
  '/misc': Misc,
  '/mail': Booklist,
  '/about': About,
};

export const routeMeta = {
  '/character': {
    pageId: 1,
    title: 'Персонаж',
    gallery: '/images/teach.jpg',
    hint: 'Обучение, сообщения, задания, статистика',
  },
  '/place': {
    pageId: 2,
    title: 'Местность',
    gallery: '/images/planet.jpg',
    hint: 'Планета, орбита, станция, галактика',
  },
  '/ships': {
    pageId: 3,
    title: 'Корабли',
    gallery: '/images/ships.jpg',
    hint: 'Флот, приказы, карта системы',
  },
  '/ware': {
    pageId: 4,
    title: 'Склад',
    gallery: '/images/warehouse.jpg',
    hint: 'Перемещение грузов между объектами',
  },
  '/trade': {
    pageId: 5,
    title: 'Торговля',
    gallery: '/images/trade.jpg',
    hint: 'Сделки, конфедерация, покупка и продажа',
  },
  '/misc': {
    pageId: 6,
    title: 'Прочее',
    gallery: '/images/enc.jpg',
    hint: 'Альянс, энциклопедия, настройки, статистика',
  },
  '/mail': {
    pageId: 1,
    title: 'Почта',
    gallery: '/images/char.jpg',
    hint: 'Сообщения персонажа',
  },
  '/about': {
    pageId: 18,
    title: 'О персонаже',
    gallery: '/images/char.jpg',
    hint: 'Профиль игрока, медали, отношения',
  },
};

