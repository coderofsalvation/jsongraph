jref = require 'json-ref-lite'
clone   = (obj) -> JSON.parse( JSON.stringify obj )
expression = require './lib/expression'
  
module.exports = ( (jg) ->

  jg.graph = false
  jg.filters = { global:{} }
  jg.bindings = []
  jg.types   = {}
  jg.parsers = {}
  
  jg.opts = 
    verbose: 0
    maxrecurse: 1
    halt: (node,data,processed) -> 
      return true if node.processed? and node.processed is @.maxrecurse 
      return true if not data?
      return false 

  jg.bind = ( nodenames, cb ) ->
    @.bindings.push
      nodenames: nodenames
      process: cb

  jg.register = (type,cb) -> @.types[type] = cb
 
  jg.evaluate = (data,opts) ->
    g = ( if opts?.graph? then opts.graph else jg.graph )
    g = clone g
    parsers = ( if opts?.parsers then opts.parsers else ['expr','ref'] )
    for parser in parsers
      jg.parsers[parser] g,data if jg.parsers[parser]? 
    jg.graph = g if not opts?.graph?
    return g

  jg._run = (node,data,cb) ->
    _ = @.opts
    if node? and not _.halt node,data
      try
        console.log "[ "+node.name+" ]\n  ├ input : "+ JSON.stringify data if @.opts.verbose > 1
        process = ( if cb? then cb else (node,data,next) -> next(node,data) )
        if node.type? and jg.types[node.type]?
          process = (node,data,next) -> 
            jg.types[node.type](node,data, () ->
              cb(node,data,next)
            )
        result = process node,data, (node,data) ->
          filter node,data for filtername,filter of jg.filters.global 
          console.log "  ├ output: "+ JSON.stringify data if jg.opts.verbose > 1
          node.processed = ( if not node.processed? then 1 else ++node.processed )
          if node.output?
            jg._run o, clone(data),cb for o in node.output
      catch err 
        return if err is "flow-stop" 
        throw err

  jg.run = (startnode,data,cb) ->
    throw 'invalid args' if ( typeof startnode != 'string' or typeof data != 'object' )
    graph = jref.resolve clone jg.graph
    node.name = name for name,node of graph.graph
    throw 'node "'+startnode+'" not found' if not graph?.graph?[ startnode ]?
    jg._run graph.graph[ startnode ],data,cb

  jg.utils =
    dump: () ->
      console.log JSON.stringify @.get(),null,2
    get: (nodename) ->
      return jg.graph if not nodename?
      return ( if jg.graph.graph[nodename]? then jg.graph.graph[nodename] else null )
    set: (name,node) ->
      jg.graph.graph[name] = ( if not node? then {name:name} else node )
      return jg.graph.graph[name]
    link: (a,b) ->
      graph = jg.graph.graph
      a = graph[a] if typeof a != "object" and graph[a]?
      b = graph[b] if typeof b != "object" and graph[b]?
      a.output = [] if not a.output?
      a.output.push b
    run: jg.run
    evaluate: jg.evaluate

  jg.init = (graph) ->
    throw 'invalid args' if ( typeof graph != 'object' or not graph.graph? )
    @.graph = graph
    return @.utils

  jg.parsers.ref  = (graph,data) -> 
    graph.data = data
    jref.resolve graph
    delete graph.data
    return graph
  
  jg.parsers.expr = expression.parse

  return jg

)({})
