module.exports = function(options, next) {
  if (typeof options == 'function') {
    next = options;
    options = {};
  }

  options.checkSuccessful = !!options.checkSuccessful;

  return function(err, response, body) {
    if (err) { return next(err, null, response, body); }

    if (options.checkSuccessful) {
      if (response.statusCode < 200 || response.statusCode >= 400) {
        return next(new Error('Successful status code expected but got ' + response.statusCode, response, null, body));
      }
    }

    if (response.headers && response.headers['content-type'].indexOf('application/json') == 0) {
      try {
        var parsed = JSON.parse(body);
        return next(null, parsed, response, body);
      } catch(e) {
        return next(e, null, response, body);
      }
    } else {
      return next(new Error('Content-Type expected "application/json"', null, response, body));
    }
  }
};