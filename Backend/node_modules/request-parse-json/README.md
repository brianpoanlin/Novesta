# request-parse-json

Simple module to parse response from request module as JSON.

# Installation

    > npm install request-parse-json --save

# Usage

```javascript
var request = require('request');
var parseJSON = require('request-parse-json');

request({
  method : 'GET',
  url : 'https://api.github.com/repos/saintedlama/request-parse-json',
  headers : {
    'Accept' : 'application/vnd.github.v3+json',
    'User-Agent' : 'request-parse-json'
  }
}, parseJSON(next)); // Pass err, response, parsed body and raw body to next

function next(err, response, repository, body) {
  // Do something...
}

```

