jg = require 'jsongraph' 

path = []

# create the graph: a<->b<-c

json =
  graph:
    a:
      output: [{"$ref": "#/b"}]
    b:
      output: [{"$ref": "#/a"}]
    c:
      output: [{"$ref": "#/a"}]

# push global filter
jg.filters.global.rememberpath = (node,data) ->
  path.push node.name

graph = jg.init json
graph.run 'b', {foo:"bar"}
