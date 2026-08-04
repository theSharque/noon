import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import { resolve } from 'path';
import { svelteOnWarn } from './svelte-onwarn.js';

const root = resolve(__dirname, 'admin');

export default defineConfig({
  root,
  plugins: [svelte({ onwarn: svelteOnWarn })],
  base: '/admin/',
  build: {
    outDir: resolve(__dirname, 'dist-admin'),
    emptyOutDir: true,
    rollupOptions: {
      input: resolve(root, 'index.html'),
    },
  },
  server: {
    port: 5174,
    fs: {
      allow: [resolve(__dirname)],
    },
    proxy: {
      '/page.php': { target: 'http://127.0.0.1:3080', changeOrigin: true },
    },
  },
});
