cdn = '//localhost:9998/'

err = (e) => console.error(e)

elem = (tag, attr) =>
  e = document.createElement(tag)
  Object.assign(e, attr)
  document.head.appendChild(e)
  return

document.write(
  '<html><head><meta charset=UTF-8><meta content="width=device-width,initial-scale=1.0,shrink-to-fit=no" name="viewport"></head><body></body></html>'
)

await navigator.serviceWorker.register("/s.js", {
  scope: '/'
})
