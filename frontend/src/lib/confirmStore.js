import { writable } from 'svelte/store';

export const confirmDialog = writable(null);

export function askConfirm({
  title = 'Подтверждение',
  message = '',
  confirmLabel = 'OK',
  cancelLabel = 'Отмена',
  danger = false,
} = {}) {
  return new Promise((resolve) => {
    confirmDialog.set({
      title,
      message,
      confirmLabel,
      cancelLabel,
      danger,
      resolve,
    });
  });
}

export function askYesNo({ title = 'Подтверждение', message = '', danger = false } = {}) {
  return askConfirm({
    title,
    message,
    confirmLabel: 'Да',
    cancelLabel: 'Нет',
    danger,
  });
}

export function closeConfirm(result) {
  let current;
  confirmDialog.update((state) => {
    current = state;
    return null;
  });
  current?.resolve?.(Boolean(result));
}
