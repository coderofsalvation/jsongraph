// Generated by CoffeeScript 1.9.3
(function() {
  var jg, json, process;

  jg = require('jsongraph');

  json = {
    graph: {
      a: {
        output: [
          {
            "$ref": "#/graph/b"
          }
        ]
      },
      b: {
        output: [
          {
            "$ref": "#/graph/a"
          }
        ]
      },
      c: {
        output: [
          {
            "$ref": "#/graph/a"
          }
        ]
      },
      d: {
        output: [
          {
            "$ref": "#/graph/c"
          }
        ]
      }
    }
  };

  process = {
    a: function(me, data, next) {
      data.a = true;
      return next(me, data);
    },
    b: function(me, data, next) {
      if (data.b != null) {
        throw 'flow-stop';
      }
      data.b = true;
      return next(me, data);
    },
    c: function(me, data, next) {
      data.c = true;
      return next(me, data);
    }
  };

  jg.opts.verbose = 2;

  jg.init(json);

  jg.run('b', {
    foo: "bar"
  }, function(me, data, next) {
    if (process[me.name] != null) {
      return process[me.name](me, data, next);
    } else {
      return next(me, data);
    }
  });

}).call(this);
