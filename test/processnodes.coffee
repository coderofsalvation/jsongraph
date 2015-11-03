jg = require 'jsongraph' 

# create the graph: b<->a<-c<-d

json =
  graph:
    a:
      output: [{"$ref": "#/graph/b"}]
    b:
      output: [{"$ref": "#/graph/a"}]
    c:
      output: [{"$ref": "#/graph/a"}]
    d:
      output: [{"$ref": "#/graph/c"}]

# bind some functions

process = 
  a: (me,data,next) -> 
    data.a = true
    next me, data 

  b: (me,data,next) ->
    throw 'flow-stop' if data.b? # stops flow if already processed
    data.b = true
    next me, data 

  c: (me,data,next) ->
    data.c = true 
    next me, data 

jg.opts.verbose = 2
jg.init json
jg.run 'b', {foo:"bar"}, (me,data,next) ->
  if process[me.name]?
    process[me.name](me,data,next) 
  else next me,data
