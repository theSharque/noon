import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import { svelteOnWarn } from './svelte-onwarn.js';

export default defineConfig({
  plugins: [svelte({ onwarn: svelteOnWarn })],
  base: '/app/',
  server: {
    port: 5173,
    proxy: {
      '/page.php': { target: 'http://127.0.0.1:3080', changeOrigin: true },
      '/reader.php': { target: 'http://127.0.0.1:3080', changeOrigin: true },
      '/music': { target: 'http://127.0.0.1:3080', changeOrigin: true },
      '/images': { target: 'http://127.0.0.1:3080', changeOrigin: true },
      '/img': { target: 'http://127.0.0.1:3080', changeOrigin: true },
    },
  },
});
