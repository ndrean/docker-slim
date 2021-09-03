import { resolve } from 'path';
import preact from '@preact/preset-vite';
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [
    RubyPlugin(),preact()
  ],
  resolve: {
    alias: {
      __: resolve(__dirname, './src'),
      react: "preact/compat",
      "react-dom": "preact/compat",
    },
    extensions: ["css"],
  },
  build: {
    brotliSize: false,
  },
})