<img alt="" src="logo.png"/>

## Usage 

    npm install --save jsonflow

or in the browser    

    <script type="text/javascript" src="jsonflow.min.js"></script>

Lets create a graph b<->a<-c :

    jflow = require 'json-dataflow' 

    json =
      a:
        output: [{"$ref": "#/b"}]
      b:
        output: [{"$ref": "#/a"}]
      c:
        output: [{"$ref": "#/a"}]

Lets bind some functions to the nodes

    process = 
      a: (node,data) -> 
        data.a = true
        console.dir data

      b: (node,data) ->
        throw 'flow-stop' if data.b? # stops flow if already processed
        data.b = true

      c: (node,data) ->
        data.c = true 

# lets run the graph

    jflow.run json, {foo:"bar"}, {root:'b', process: process }
 
> NOTE: see javascript version [here](/test/test.js)

output:

    { foo: 'bar', b: true, a: true }

# Feature: custom and global filters

Filters are useful to easily process data on a global level.
This is especially handy for debugging and safety purposes.

    # push global filter
    jflow.filters.global.rememberpath = (node,data) ->
      path.push node.name

    jflow.run json, {foo:"bar"}, {root:'b', process: process }
    console.log "path: "+path.join '->'

output:

    path: b->a

# Notes 

`jflow.opts.maxrecurse` is set to '1' by default to prevent infinite recursion. 
You can set this to another value, but you'll need to prepare your process-functions to keep track of this instead.
