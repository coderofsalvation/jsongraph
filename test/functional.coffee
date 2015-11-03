jg = require 'jsongraph' 
jg.opts.verbose = 2
graph = jg.init {graph:{}}

# add nodes
a = graph.set "a"
b = graph.set "b"
c = graph.set "c"

# link a->b and c->a
graph.link a,b
graph.link "b","c"

graph.dump()

graph.run 'a', {foo:"bar"}, (me,data,next) ->
  data.b = true if me.name is 'b'
  next me,data
