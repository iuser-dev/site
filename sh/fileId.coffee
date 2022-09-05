#!/usr/bin/env coffee

> @iuser/pg
  @iuser/xxhash3-wasm > hash128
  @iuser/ossput
  fs/promises > readFile
  ./pg.dist.mjs:CONF
  @iuser/wasm-map > BinU32Map
  ./b68
###
./b68
./ossLi.mjs
put = await ossput ossLi, 'user-cdn'
###

Q = await pg CONF

host_id = await Q.host.valId 'usr.tax'

TODAY = parseInt new Date()/86400000

HASH_ID = 'hash_id'

ID = (await Q.host_hash.max(HASH_ID).get0({host_id})) or 0

PRE = new BinU32Map

await do =>
  for [hash_id,bin] from await Q(
    '''select hash_id,hash from host_hash where host_id=? and day = ( select day from host_hash where host_id=? and day!=0 order by id desc limit 1 )'''
    [
      host_id, host_id
    ]
  )
    PRE.set new Uint8Array(bin), hash_id

TO_UPDATE = []

< (fp)=>
  bin = new Uint8Array(await readFile(fp))
  hash = hash128 bin

  hash_id = PRE.get(hash)

  if hash_id
    uploaded = true
  else
    uploaded = false
    r = (await Q.host_hash.select(HASH_ID).where({
      host_id
      hash
    }))[0]
    if r
      hash_id = r[0]

  if hash_id
    name = b68 hash_id
  else
    loop
      hash_id = ++ID
      name = b68(hash_id)
      if name.replaceAll('.','')
        break

    await Q.host_hash.insert({
      hash
      hash_id
      host_id
      day:0
    })

  TO_UPDATE.push hash_id
  [name, uploaded]


< update = =>
  Q.host_hash.where({
    host_id
  }).whereIn(HASH_ID, TO_UPDATE).update(day:TODAY)

