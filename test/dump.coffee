undirender = require 'undirender'
jref       = require 'json-ref-lite'
graph = []

json = require __dirname+'/graph.coffee' 
json = jref.resolve json

json[name].name = name for name,node of json 
for k,node of json 
  if node.output? 
    for o in node.output
      graph.push [node.name,o.name]

nodes = graph.length 
space = 2
s = undirender nodes*space, parseInt((nodes/2)*space), graph
console.log(s);
