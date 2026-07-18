import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
  plugins: [svelte()],
  base: '/app/',
  server: {
    port: 5173,
    proxy: {
      '/page.php': { target: 'http://127.0.0.1:8080', changeOrigin: true },
      '/reader.php': { target: 'http://127.0.0.1:8080', changeOrigin: true },
      '/music': { target: 'http://127.0.0.1:8080', changeOrigin: true },
      '/images': { target: 'http://127.0.0.1:8080', changeOrigin: true },
    },
  },
});
