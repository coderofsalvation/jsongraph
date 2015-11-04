jg = require 'jsongraph' 

path = []

# create the graph: a<->b<-c

json =
  graph:
    a:
      "$ref": [{"$ref": "#/graph/b"}]
    b:
      "$ref": [{"$ref": "#/graph/a"}]
    c:
      "$ref": [{"$ref": "#/graph/a"}]

# push global filter
jg.filters.global.rememberpath = (node,data) ->
  path.push node.name

graph = jg.init json
graph.run 'b', {foo:"bar"}

console.log path.join '->'
