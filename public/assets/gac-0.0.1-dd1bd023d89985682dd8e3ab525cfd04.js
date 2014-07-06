(function() {
  var gac;

  gac = {
    initialized: false,
    clean: function(callback) {
      console.log('Operating cleaning...');
      if (gac.initialized) {
        Gibberish.clear();
        gac.initialized = false;
      }
      return callback(!gac.initialized);
    },
    init: function(callback) {
      var e;
      console.log('initializing Gibberish Audio Client');
      try {
        Gibberish.init();
        Gibberish.Time["export"]();
        Gibberish.Binops["export"]();
        gac.initialized = true;
        if (callback) {
          return callback(gac.initialized);
        }
      } catch (_error) {
        e = _error;
        return callback(e);
      }
    },
    execute: function(compile, data, callback) {
      var e, js;
      try {
        js = unescape(data);
        js = compile(js, {
          bare: true,
          map: {}
        });
        js = unescape(js);
        return callback(!js, js);
      } catch (_error) {
        e = _error;
        return callback(true, "" + compile.prototype.name + ":\n" + js.map + "\n" + e);
      }
    },
    run: function(callback) {
      return gac.execute(CoffeeScript.compile, window.editor.getValue(), callback);
    },
    checkfloats: function(k, v) {
      var b, t, _i, _len, _ref;
      b = false;
      _ref = ['freq', 'amp', 'pulsewidth', 'chance', 'pitchMin', 'pitchMax', 'pitchChance', 'cutoff', 'Q', 'roomSize', 'dry', 'wet'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        if ((typeof v === 'object') && k === t) {
          b = true;
          break;
        }
      }
      return b;
    },
    checkints: function(k, v) {
      var b, t, _i, _len, _ref;
      b = false;
      _ref = ['mode', 'rate', 'amount'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        if ((typeof v === 'object') && k === t) {
          b = true;
          break;
        }
      }
      return b;
    }
  };

  window.INIT = function(time, callback) {
    return setTimeout(function() {
      return gac.clean(function(cleaned) {
        return gac.init(function(initialized) {
          return callback();
        });
      });
    }, time);
  };

  window.TASK = function(time, callback) {
    return setTimeout(function() {
      return callback();
    }, time);
  };

  window.GEN = function(n, o, c) {
    var e, k, u, v;
    try {
      u = new Gibberish[n];
      console.log("" + u + " " + n + ":");
      for (k in o) {
        v = o[k];
        console.log("  " + k + ":" + v);
        u[k] = v;
      }
      if (c) {
        return c(u);
      } else {
        return u;
      }
    } catch (_error) {
      e = _error;
      return alert(e);
    }
  };

  window.GEN_RAND = function(n, o, c) {
    var k, v;
    for (k in o) {
      v = o[k];
      if (gac.checkfloats(k, v)) {
        o[k] = Gibberish.rndf(v[0], v[v.length - 1]);
      } else if (gac.checkints(k, v)) {
        o[k] = Gibberish.rndi(v[0], v[v.length - 1]);
      } else {
        o[k] = v;
      }
    }
    return window.GEN(n, o, c);
  };

  window.GEN_FN = function(n, o, c) {
    var k, v;
    for (k in o) {
      v = o[k];
      if (typeof v === 'Function') {
        o[k] = v();
      }
    }
    return window.GEN(n, o, c);
  };

  window.GEN_SEQ = function(o, c) {
    var k, u, v, _ref;
    _ref = o.keysAndValues;
    for (k in _ref) {
      v = _ref[k];
      o.keysAndValues[k] = v();
    }
    o.durations = o.durations();
    u = new Gibberish.Sequencer(o);
    if (c) {
      return c(u);
    } else {
      return u;
    }
  };

}).call(this);
