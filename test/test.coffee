jflow = require 'jsonflow' 

# create the graph: b<->a<-c<-d

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
  a: (me,data,next) -> 
    data.a = true
    console.dir data
    next me, data 

  b: (me,data,next) ->
    throw 'flow-stop' if data.b? # stops flow if already processed
    data.b = true
    next me, data 

  c: (me,data,next) ->
    data.c = true 
    next me, data 

jflow.run json, {foo:"bar"}, {root:'b', process: process }

jflow.run json, {foo:"bar"}, {root:'d', process: process }
