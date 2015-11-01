jflow = require 'jsonflow' 

# create the graph: a<->b<-c

json =
  a:
    output: [{"$ref": "#/b"}]
  b:
    output: [{"$ref": "#/a"}]
  c:
    output: [{"$ref": "#/a"}]
  d:
    output: [{"$ref": "#/c"}]

# bind some functions

process = 
  a: (node,data) -> 
    data.a = true
    console.dir data

  b: (node,data) ->
    throw 'flow-stop' if data.b? # stops flow if already processed
    data.b = true

  c: (node,data) ->
    data.c = true 

jflow.run json, {foo:"bar"}, {root:'b', process: process }

jflow.run json, {foo:"bar"}, {root:'d', process: process }
