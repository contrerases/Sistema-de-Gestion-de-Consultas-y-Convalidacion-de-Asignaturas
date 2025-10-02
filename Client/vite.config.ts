import { fileURLToPath, URL } from 'node:url';

import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

import tailwind from 'tailwindcss';
import autoprefixer from 'autoprefixer';

// https://vitejs.dev/config/
export default defineConfig({
  css: {
    postcss: {
      plugins: [tailwind(), autoprefixer()],
    },
  },
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
    extensions: ['.ts', '.tsx', '.js', '.jsx', '.vue', '.json'], // Extensiones que resolver automáticamente
  },
  server: {
    host: '0.0.0.0', // Importante para Docker
    port: 5173,
    watch: {
      usePolling: true, // Para hot reload en Windows/Docker
    },
  },
});
