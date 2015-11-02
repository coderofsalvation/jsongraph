jref = require 'json-ref-lite'
typeshave = require('typeshave').typesafe
clone   = (obj) -> JSON.parse( JSON.stringify obj )

module.exports = ( () ->

  @.opts = 
    maxrecurse: 1
    halt: (node,data,processed) -> 
      return true if node.processed? and node.processed is @.maxrecurse 
      return true if not data? or not node.process?
      return false 

  @.filters = { global:{}, custom:{} }

  @._run = (node,data,name,processed) ->
    _ = @.opts
    if node? and not _.halt node,data
      try
        console.log "->"+node.name if process.env.DEBUG
        result = node.process node,data, (node,data) ->
          filter node,data for filtername,filter of @.filters.global 
          node.processed = ( if not node.processed? then 1 else ++node.processed )
          if node.output?
            for o in node.output
              @._run o, clone data if o?.process?
      catch err 
        return if err is "flow-stop" 
        throw err

  @.run = typeshave
    graph: { type: "object", required: true}
    data:  { type: "object", required: true }
    opts:
      type: "object" 
      properties:
        root: { type:"string", required: true }
  , (graph,data,opts) ->
    graph = jref.resolve clone graph
    for name,node of graph
      node.name = name 
      node.process = opts.process[name] if opts.process?[name]?
    @._run graph[ opts.root ],data

  return @

)()
