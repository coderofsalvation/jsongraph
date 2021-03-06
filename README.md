<img alt="" src="logo.png"/>

Dont think trees, think jsongraph, think graphmorphic applications.

> NOTE #1: this module is based on [json-ref-lite](https://npmjs.org/packages/json-ref-lite). Use json-ref-lite if you just want to work with plain jsongraphs, without the dataflow runtime below.

> NOTE #2: for server/clients sharing a restgraph see [ohmygraph](https://npmjs.org/packages/ohmygraph)

## Usage 

    npm install --save jsongraph

or in the browser (adds 3.3k gzipped)

    <script type="text/javascript" src="jsongraph.min.js"></script>

Graph b<->a<-c expressed in json using jsonschema pointers:

    jg = require 'jsongraph' 
    json = {
      "a": { "$ref": [{"$ref":"/graph/b"}] },
      "b": { "$ref": [{"$ref":"/graph/a"}] },
      "c": { "$ref": [{"$ref":"/graph/a"}] }
    }

> NOTE: see javascript version [here](/test/test.js)

# Or on the fly 

    jg = require 'jsongraph' 
    jg.opts.verbose = 2
    graph = jf.init {graph:{}}

    # add nodes
    a = graph.add "a"
    b = graph.add "b"
    c = graph.add "c"

    # link a->b and c->a
    graph.link a,b
    graph.link "c","a"

> NOTE: see javascript version [here](/test/functional.js)

# Lets run the graph!

    graph.run 'c', {foo:"bar"}

output:

    [ b ]
      ├ input : {"foo":"bar"}
      ├ "$ref": {"foo":"bar"}
    [ a ]
      ├ input : {"foo":"bar"}
      ├ "$ref": {"foo":"bar"}
 
> NOTE: see javascript version [here](/test/test.js)

# Feature: register plugins & process data

You can process data, and do graph- or flowbased programming like so:

    json =
      graph:
        a: { type: "foo", "$ref": [{"$ref": "#/graph/b"}] }
        b: { "$ref": [{"$ref": "#/graph/a"}] }

    jg.register 'foo', (me,data,next) ->
      data.foo = true;
      next me,data

output:

    [ b ]
      ├ input : {}
      ├ "$ref": {"b":true}
    [ a ]
      ├ input : {"b":true}
      ├ "$ref": {"b":true,"foo":true}

Now when `data.foo` is set, whenever a node with type `foo` is executed.

# Feature: bind custom actions to nodes 

When the graph is executed, you can easily walk the graph and pause/do stuff:

    # bind custom functions
    process = 
      b: (me,data,next) ->
        data.b = true
        next me, data 

    graph.run 'b', {}, (me,data,next) -> 
      if process[me.name]?                 # every node
        process[me.name](me,data,next)     # will call
      else next me,data                    # this function

# Feature: global filters

Filters are useful to easily process data on a global level.
This is especially handy for debugging and safety purposes.

    path = []
    jg.filters.global.rememberpath = (node,data) ->
      path.push node.name
    graph.run 'b'
    console.log path.join '->'

output:

    b->a

# Graph Expressions

(Re)evaluate data into your graph before calling `run()`:

    json =
      graph:
        a: { value: "{book.category[0].text}" }
        b:
          value: "{foo}"
          value_int: {"$ref":"#/data/book/code"}
          value_str: {"$ref":"#/data/book/category[0].text"}

    data = 
      book:{ code: 1, category: [{text: "fairytales stories"}] }
      foo: () -> ++@.book.code

    graph.evaluate data, {parsers:["expr","ref"]}
    graph.dump()

output:

    {
      "graph": {
        "a": { "value": "fairytales stories" },
        "b": { "value": "2", "value_int": 1, "value_str": "fairytales stories" }
      }
    }

Instead of evaluating the whole graph, you can also just evaluate a single node (variable):

    graph.set 'a', graph.evaluate( data, {graph:graph.get('a')} )

> See the [javascript](/test/expressions.js) or [coffeescript](/test/expressions.coffee) here

# Notes 

* increase the `jg.opts.verbose` value for more verbose console.log "$ref"
* `jg.opts.maxrecurse` is set to '1' by default to prevent infinite recursion. 
You can set this to another value, but you'll need to prepare your process-functions to keep track of this instead.
* overriding the `jg.opts.halt` function allows you to implement your own node-halting flow

# Philosophy

* everything, including life is a unidirected graph
* peanuts are nice
