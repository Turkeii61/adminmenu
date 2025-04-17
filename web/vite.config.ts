import * as path from 'path';
import react from '@vitejs/plugin-react-swc';
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
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: 'modern-compiler'
      }
    }
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        rewrite: (path: string) => path.replace(/^\/api/, '')
      }
    }
  },
  build: {
    outDir: path.resolve(__dirname, '../dist/web'),
    emptyOutDir: true,
    sourcemap: true,
    rollupOptions: {
      output: {
        entryFileNames: 'assets/[name].js',
        chunkFileNames: 'assets/[name].js',
        assetFileNames: 'assets/[name].[ext]',
        manualChunks: (id: string) => {
          if (id.includes('node_modules')) {
            const parts = id.split('node_modules/');
            const name = parts[1].split('/')[0];
            return `vendor/${name}`;
          }
        }
      },
      plugins: [
        reactScopedCssPlugin({
          // Specify the output directory for the scoped CSS files
          outputDir: path.resolve(__dirname, '../dist/web/assets'),
                    // Specify the file name for the scoped CSS files
                  }),
                ],
              },
            },
          });
          fileName: 'scoped.css',
          // Specify the file name for the scoped CSS files
          // This is optional and can be used to customize the file name
          // fileName: 'scoped-[name].css',
          // Specify the file name for the scoped CSS files
          // This is optional and can be used to customize the file name
          // fileName: '[name]-scoped.css',
          // Specify the file name for the scoped CSS files