jg = require 'jsongraph' 

json =
  graph:
    a:
      value: "{book.category[0].text}"
    b:
      value: "{foo}"
      value_int: {"$ref":"#/data/book/code"}
      value_str: {"$ref":"#/data/book/category[0].text"}
      

data = 
  book:{ code: 1, category: [{text: "fairytales stories"}] }
  foo: () -> ++@.book.code

jg.opts.verbose = 2
graph = jg.init json

# whole graph
graph.evaluate data
graph.dump()
  
# node specific 
data.book.category[0].text = "foo"
graph.set 'a', graph.evaluate( data, {graph:graph.get('a')} )
graph.dump()

# whole graph but define parse order instead of first parsing expressions before jsonreferences
graph.evaluate data, {parsers:["ref","expr"]}
graph.dump()
