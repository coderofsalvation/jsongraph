expr = require 'property-expr'
module.exports = ( (me) ->

  me.__parse = (k,data) ->
    return k if typeof k != 'string'
    integer = false  
    itemstr = k.replace /(\{)(.*?)(\})/g, ($0,$1,$2) -> 
      return String('{}') if not $2?
      return '' if not data?
      result = ''
      if data[$2]? and typeof data[$2] == 'function'
        result = data[$2]()
      else 
        if data[$2]?
          result = data[$2] 
        else
          try
            result = expr.getter( $2 )(data)
          catch err
            result = ''
      me.__parse result
      return result

  me.parse = (json,data) ->
    if typeof json is "object"
      for k,v of json
        nk = me.__parse k, data
        nv = me.__parse v, data
        nv = me.parse nv,data if typeof nv is 'object'
        json[nk] = nv if nv? 
        delete json[k] if nk != k
    return json

  return me

)({})
