jflow = require 'jsonflow' 

path = []

# create the graph: a<->b<-c

json =
  a:
    output: [{"$ref": "#/b"}]
  b:
    output: [{"$ref": "#/a"}]
  c:
    output: [{"$ref": "#/a"}]

# bind custom and global functions 

process = {}
process.increment = (me,data,next) ->
  data.arr = [] if not data.arr?
  data.arr.push new Date()
  next me, data

process.a = process.b = process.increment # re-use function 

# push custom filter
jflow.filters.custom.debug = (node,data) ->
  obj = {}; obj[ node.name ] = data
  console.log JSON.stringify obj,null,2

# push global filter
jflow.filters.global.rememberpath = (node,data) ->
  path.push node.name

jflow.run json, {foo:"bar"}, {root:'b', process: process }
console.log "path: "+path.join '->'
