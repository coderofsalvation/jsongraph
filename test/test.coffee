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

jg.opts.verbose = 2
graph = jg.init json
graph.run 'b', {foo:"bar"}
