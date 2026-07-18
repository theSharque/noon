import Stub from '../routes/Stub.svelte';

export const routes = {
  '/character': Stub,
  '/place': Stub,
  '/ships': Stub,
  '/ware': Stub,
  '/trade': Stub,
  '/misc': Stub,
  '/mail': Stub,
};

export const routeMeta = {
  '/character': {
    title: 'Персонаж',
    gallery: '/images/teach.jpg',
    hint: 'Обучение, сообщения, задания, статистика',
  },
  '/place': {
    title: 'Местность',
    gallery: '/images/planet.jpg',
    hint: 'Планета, орбита, станция, галактика',
  },
  '/ships': {
    title: 'Корабли',
    gallery: '/images/ships.jpg',
    hint: 'Флот, приказы, карта системы',
  },
  '/ware': {
    title: 'Склад',
    gallery: '/images/warehouse.jpg',
    hint: 'Перемещение грузов между объектами',
  },
  '/trade': {
    title: 'Торговля',
    gallery: '/images/trade.jpg',
    hint: 'Сделки, конфедерация, покупка и продажа',
  },
  '/misc': {
    title: 'Прочее',
    gallery: '/images/enc.jpg',
    hint: 'Альянс, энциклопедия, настройки, статистика',
  },
  '/mail': {
    title: 'Почта',
    gallery: '/images/char.jpg',
    hint: 'Сообщения персонажа',
  },
};

