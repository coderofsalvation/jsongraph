jg = require 'jsongraph' 

# create the graph: b<->a

json =
  graph:
    a:
      type: "foo"
      output: [{"$ref": "#/graph/b"}]
    b:
      output: [{"$ref": "#/graph/a"}]

# register plugin 
jg.register 'foo', (me,data,next) ->
  data.foo = true;
  next me,data

jg.opts.verbose = 2
graph = jg.init json

# bind custom functions
process = 
  b: (me,data,next) ->
    data.b = true
    next me, data 

graph.run 'b', {}, (me,data,next) ->
  if process[me.name]?
    process[me.name](me,data,next) 
  else next me,data
