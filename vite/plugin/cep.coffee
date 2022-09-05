import compile from 'coffee_plus/compile.js'

export default {
  name:'coffee_plus_loader'
  transform:(code, filename)=>
    if filename.endsWith '.coffee'
      r = compile code,{
        filename
        bare:true
        sourceMap:true
      }
      {
        code: r.js
        map: r.v3SourceMap
      }
}
