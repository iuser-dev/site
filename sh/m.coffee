#!/usr/bin/env coffee

> @rmw/thisdir
  fs > unlinkSync
  path > dirname join
  @iuser/read
  @iuser/write
  @iuser/replace
  coffee_plus/compile

ROOT = dirname thisdir(import.meta)

DIST = join ROOT, 'dist'

do =>
  init = read join ROOT,'src/init.coffee'
  init = compile init, {bare:true}

  out = {
    js:[]
    css:[]
  }
  html = join DIST, 'index.html'

  for i from read(html).split('=')
    if i.startsWith '/'
      i = i.split('>')[0][1..]
      pos = i.lastIndexOf '.'
      fp = join DIST, i
      out[i[pos+1..]].push read fp
      unlinkSync fp

  css = out.css.join('')
  css = JSON.stringify(css)[1...-1].replaceAll('\\"','"').replaceAll('\'','\\\'')

  out.js.unshift '(async ()=>{'+init.replace('</head>',"<style>#{css}</style></head>")+'})();\n'

  js = """
  const DOC=document;
  """+out.js.join('\n').replaceAll('document','DOC')

  await write join(DIST,'m.js'), js
  return
