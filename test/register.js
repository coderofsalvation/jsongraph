// Generated by CoffeeScript 1.9.3
(function() {
  var graph, jg, json, process;

  jg = require('jsongraph');

  json = {
    graph: {
      a: {
        type: "foo",
        "$ref": [
          {
            "$ref": "#/graph/b"
          }
        ]
      },
      b: {
        "$ref": [
          {
            "$ref": "#/graph/a"
          }
        ]
      }
    }
  };

  jg.register('foo', function(me, data, next) {
    data.foo = true;
    return next(me, data);
  });

  jg.opts.verbose = 2;

  graph = jg.init(json);

  process = {
    b: function(me, data, next) {
      data.b = true;
      return next(me, data);
    }
  };

  graph.run('b', {}, function(me, data, next) {
    if (process[me.name] != null) {
      return process[me.name](me, data, next);
    } else {
      return next(me, data);
    }
  });

}).call(this);
