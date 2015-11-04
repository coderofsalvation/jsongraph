jg = require 'jsongraph' 

# create the graph: b<->a<-c<-d
json =
  graph:
    a:
      "$ref": [{"$ref": "#/graph/b"}]
    b:
      "$ref": [{"$ref": "#/graph/a"}]
    c:
      "$ref": [{"$ref": "#/graph/a"}]

jg.opts.verbose = 2
graph = jg.init json
graph.run 'b', {foo:"bar"}

#graph.jsonschema()
