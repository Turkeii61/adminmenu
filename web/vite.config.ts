import path from 'path';
import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';
import { reactScopedCssPlugin } from 'rollup-plugin-react-scoped-css';


export default defineConfig({
  plugins: [react(), reactScopedCssPlugin()],
  base: '/web/',
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    }
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: 'modern-compiler'
      }
    }
  },