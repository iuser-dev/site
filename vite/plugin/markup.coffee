> path > join
  fs > existsSync writeFileSync
  @iuser/replace
  @iuser/snake > SNAKE

import * as I18N from '../../src/gen/i18n.js'

styl = 'styl/'
ext = 'styl'

# https://svelte.dev/docs#compile-time-svelte-preprocess
LI = [
  (code)=> # i18n
    code = replace(
      code
      '<template lang="pug">'
      '</template>'
      (pug)=>
        pug.replaceAll(
          /(['"\s\(]|\|\s)>([\w_]+)/g
          (m,p1,p2)=>
            "#{p1}{i18n[#{I18N[SNAKE p2]}]}"
        )
    )

    if /\bi18n\[/.test code
      code = replace(
        code
        '<script lang="coffee">'
        '</script>'
        (txt)=>
          li = ['\n> ~/I18n.coffee > i18nOnMount']
          if not /\bonMount\b/.test(txt)
            li.push '  svelte > onMount'
          li.push '''+ i18n'''
          li.push txt
          li.push '''\
  onMount i18nOnMount (o)=>
    i18n = o
    return\n'''
          li.join('\n')
      )
    code
]

< ({ content:code, filename }) =>
  for i in LI
    code = i(code, filename)
  {
    code
  }
