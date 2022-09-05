> ../../src/gen/I18N_VER.js

PRODUCTION = process.env.NODE_ENV == 'production'

if PRODUCTION
  I18N_CDN = '/i18n.usr.tax/'+I18N_VER+'/'
else
  I18N_CDN = 'i18n/'

< {
  __I18N_CDN__: "'/#{I18N_CDN}'"
}
