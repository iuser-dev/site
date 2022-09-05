> path > join dirname
  @rmw/thisdir
  lodash-es > merge
  ./plugin/markup.js
  ./plugin/cep.js
  ./plugin/define.js

import sveltePreprocess from '@iuser/svelte-preprocess'
import vitePluginStylusAlias from './plugin/vite-plugin-stylus-alias.mjs'
import pug from 'pug'
import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'
import { writeFileSync,renameSync } from 'fs'
import import_pug from './plugin/pug.js'

ROOT = thisdir(import.meta)
DIST = join ROOT,'dist'
SRC = join ROOT,'src'
FILE = join ROOT,'file'
PRODUCTION = process.env.NODE_ENV == 'production'

INDEX_HTML = 'index.html'
SRC_INDEX_HTML = join SRC,INDEX_HTML
writeFileSync(
  SRC_INDEX_HTML
  pug.compileFile(join SRC, 'index.pug')({
  })
)

host = '0.0.0.0' or env.VITE_HOST
port = 5555 or env.VITE_PORT

config = {
  define
  publicDir: join ROOT, 'public'
  plugins: [
    cep
    svelte(
      preprocess: [
        {
          markup
        }
        sveltePreprocess(
          coffeescript: {
            label:true
            sourceMap: true
          }
          #customElement:true
          stylus: true
          pug: true
        )
      ]
    )
    vitePluginStylusAlias()
    import_pug()
  ]
  clearScreen: false
  server:{
    host
    port
    strictPort: true
    fs:
      allow: [dirname ROOT]
    ###
    proxy:
      '^/[^@.]+$':
        target: "http://#{host}:#{port}"
        rewrite: (path)=>'/'
        changeOrigin: false
    ###
  }
  resolve:
    alias:
      ":": join(ROOT, "file")
      '~': SRC
  esbuild:
    charset:'utf8'
    legalComments: 'none'
    treeShaking: true
  root: SRC
  build:
    outDir: DIST
    assetsDir: '/'
    assetsInlineLimit: 0
    rollupOptions:
      input:
        index:SRC_INDEX_HTML
    target:['esnext']
    emptyOutDir: true
}

config = merge config, await do =>
  if PRODUCTION
    FILENAME = '[name].[hash].[ext]'
    JSNAME = '[name].[hash].js'

    return {
      plugins:[
        (await import('./plugin/mini_html.js')).default
      ]
      base: '/'
      build:
        rollupOptions:
          output:
            chunkFileNames: JSNAME
            assetFileNames: FILENAME
            entryFileNames: "m.js"
    }
  else
    return {
      plugins:[
        {
          name:'html-img-src'
          transformIndexHtml:(html)=>
            html.replaceAll(
              'src=":/'
              'src="/@fs'+FILE+'/'
            )
        }
      ]
    }


export default defineConfig config
