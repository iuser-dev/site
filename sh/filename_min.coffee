#!/usr/bin/env coffee

> @rmw/thisdir
  @iuser/write
  @iuser/read
  @iuser/ossput
  @rmw/pool:Pool
  ./config > OSS_CDN HTTP_CDN
  path > dirname join
  fs/promises > rename readFile opendir
  fs > existsSync mkdirSync unlinkSync
  mime-types:Mime
  ./fileId:fileId > update
  ./ossLi.mjs

ROOT = dirname thisdir import.meta
DIST = join ROOT, 'dist'

IGNORE = await do =>
  ignore = new Set()

  for await fp from await opendir join(ROOT,'public')
    if not ( fp.isFile() or fp.isSymbolicLink() )
      continue
    ignore.add fp.name

  ignore

css_js_html = new Map()
to_replace = []

LOCAL = ['index.html','index.htm','s.js']

for await fp from await opendir DIST
  if not fp.isFile()
    continue
  fp = fp.name
  if IGNORE.has fp
    continue
  name = fp.split('.')
  ext = name.at -1
  hex = name.at -2
  if ['htm','html','css','js'].includes(ext)
    css_js_html.set(
      fp
      await readFile(join(DIST,fp),'utf8')
    )
  if not LOCAL.includes(fp)
    to_replace.push fp

to_replace.sort (a,b)=>
  a.length - b.length

fp_name = new Map
to_upload = new Set

for i from to_replace
  fp = join DIST, i
  [name,uploaded] = await fileId fp
  fp_name.set i, name
  if not uploaded
    to_upload.add i


CDN = '//'+HTTP_CDN+'/'

for [k,v] from css_js_html.entries()
  for [f,t] from fp_name.entries()
    t = CDN+t.replaceAll('$','$$$$')
    v = v.replaceAll('/'+f,t)
  if LOCAL.includes(k)
    css_js_html.delete k
    await write(
      join(DIST,k)
      v
    )
  else
    css_js_html.set(k,v)

put = await ossput ossLi, OSS_CDN
pool = Pool 20

for i in to_replace
  fp = join DIST,i
  if to_upload.has i
    name = fp_name.get i
    console.log '↑',i, 'https:'+CDN+name
    mime = Mime.lookup i
    if mime == 'application/javascript'
      mime = 'text/javascript'
    bin = css_js_html.get(i)
    if not bin
      bin = await readFile fp
    await pool put, name, bin, mime
  unlinkSync fp

await pool.done

await update()
await write(
  join(DIST,'index.html')
  "<!doctype html><script src=#{CDN}#{fp_name.get('m.js')}></script>"
)
process.exit()

