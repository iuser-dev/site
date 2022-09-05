<template lang="pug">
main
  nav
    a(href="https://User.Tax") User.Tax
    a(href="/") 首页
    a(href="/doc") 文档
    a(href="/about") 关于
    u-i18n
  u-auth
    b(slot="logo")
    b(slot="org")
      b User.Tax
      b
        i-slogan
</template>

<script lang="coffee">
> @user.tax/ui/red.css:
  @user.tax/ui/Box.css:

  svelte > onMount
  @user.tax/ui > uI18n uAuth
  @user.tax/ui/I18n.js:I18n > I18N_CDN
  @user.tax/ui/lang.js
  @user.tax/ui/way.js > MAIL PHONE
  typed.js:Typed
  ~/gen/i18n > TYPE SLOGAN
  ~/I18n.coffee:getI18n
  @user.tax/ui/Box.js:Box > xClose escClose

uI18n()
uAuth()

{assign} = Object
doc = document
tag = (t) =>
  doc.getElementsByTagName("u-" + t)[0]

a_agree = "//juejin.cn"

type = (elem) =>
  elem.typed?.destroy()
  backDelay = 999
  slogan = i18n[SLOGAN]
  typed = elem.typed = new Typed(
    elem
    {
      strings: ["", i18n[TYPE], i18n[SLOGAN] + "^" + 3 * backDelay]
      typeSpeed: 150
      backSpeed: 45
      backDelay
      onComplete: =>
        typed.destroy()
        delete elem.typed
        elem.innerText = slogan
        return
    }
  )
  return

:$
  if Array.isArray i18n
    for i from doc.getElementsByTagName('i-slogan')
      type i

onMount =>
  assign(
    tag("i18n")
    {
      li: lang
      change: (lang) =>
        Promise.all([
          (lang) =>
            I18n(I18N_CDN+lang)
            return
          getI18n
        ].map((f) => f(lang))).finally =>
          doc.body.className = "I18N" + lang
        return
    }
  )
  assign(
    tag("auth").form
    {
      a_agree
      a_pwd_reset: "/user/pwd/reset"
      way: [MAIL, PHONE]
      box: =>
        escClose xClose Box(
          """<iframe style="border:0;max-width:700px;width:80vw;height:80vh" src="#{a_agree}"></iframe>"""
        )
        return
    }
  )
  return
</script>

<style lang="stylus">
:global
  @import 'styl/auth.styl'

main
  align-items center
  background url(':/svg/bg.svg') no-repeat
  display flex
  flex-direction column
  height 100%
  justify-content center
  width 100%

nav
  align-items center
  background rgba(255, 255, 255, 0.6)
  box-shadow 0 1em 1em -1em #ccc inset
  display flex
  height 4rem
  justify-content center
  user-select none
  width 100%

  &>u-i18n, &>a
    margin 0 1em

  &>a
    &:first-child
      font-family J
      margin-bottom -0.3em

    border-bottom 2px solid transparent
    color #000
    font-size 18px
    font-weight 500

    &:hover
      border-color #f40
      color #f40
</style>
