# serviceWorker

VERSION = 1

HOST = location.host

DECODER = new TextDecoder()

+ CACHE

sleep = (n)=>
  new Promise (resolve)=>
    setTimeout(resolve, n)


Ok = (res)=>
  [200,304].includes(res.status)

Now = =>
  parseInt new Date/1000

V = '//localhost:9998/'

upgrade = =>
  pre = await CACHE.match V
  if pre
    reader = pre.body.getReader()
    pre = ''
    done = true
    while done
      {done,value} = await reader.read()
      pre += DECODER.decode value

  r = await fetch(url)
  if r.status == 200
    rc = new Response(r.clone().body, r)
    console.log pre, await r.text()
    CACHE.put(url, rc)

get = (req) =>
  if (new URL(req.url)).host != HOST
    config = {
      credentials: "omit"
      mode: "cors"
    }
    try
      res = await fetch(req, config)
    catch e
      # 可有是 no-cors
      delete config.mode
      res = await fetch(req, config)
  else
    res = await fetch(req)

  if res
    if res.status == 200
      rc = new Response(res.clone().body, res)
      rc.headers.set "_", Now().toString(36)
      CACHE.put(req, rc)

  return res

# TODO 定期清理缓存，超过30天没访问的东西就清理掉

cacheGet = (req)=>
  caches.match(req).then (res)=>
    if res
      diff = Now() - parseInt(res.headers.get('_'), 36)
      if req.url.endsWith V
        if diff > 60
          get(new Request V)
      else
        # 5e7/86400 = 578
        if diff > 6e7
          r = get req
          if diff > 7e7
            return r
      return res
    n = 9
    loop
      try
        return await get(req)
      catch err
        if n--
          console.error req,err
          await sleep(200)
        else
          throw err
    return


for k, v of {

install:(event)=>
  event.waitUntil(skipWaiting())
  return

activate: (event) =>
  event.waitUntil Promise.all [
    clients.claim()
    do =>
      CACHE = await caches.open( VERSION )
      return
  ]
  # console.log fetch('//localhost:9998/v')
  return

fetch: (event) =>
  {method} = req = event.request

  if ["GET", "OPTIONS"].includes(method)

    {host} = url = new URL(req.url)

    is_self = (host == HOST)
    if is_self
      {pathname} = url
      if pathname.indexOf(".") < 1 # 没有 . 都重定向到首页
        req = new Request("/", { method })
    #else if not host.startsWith('cdn.')
    #  return

    event.respondWith(
      cacheGet(req)
    )
  return
}
  addEventListener(k,v)

