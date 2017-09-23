/**
 * Created by Poppro on 9/23/17.
 */
var express = require('express');
var router = express.Router();
var admin = require("firebase-admin");
var fs = require('fs');
var request = require("request")
var parseJSON = require('request-parse-json');

var url = "https://api.coinmarketcap.com/v1/ticker/?limit=40";

//connect to firebase
admin.initializeApp({
    credential: admin.credential.cert('./private/novesta-da8f8-firebase-adminsdk-8r3tj-30eaefb576.json'),
    databaseURL: 'https://novesta-da8f8.firebaseio.com',
});

var db = admin.database();

var ref = db.ref("master_crypto");
var names = db.ref("name_crypto");

/* GET users listing. */
router.get('/', function(req, res, next) {
    //grab data
    request({
        method : 'GET',
        url : url
    }, parseJSON(next)); // Pass err, response, parsed body and raw body to next

    function next(err, response, repository, body) {
        var obj = JSON.parse(body);
        obj[0]['img'] = 'bitcoin.png';
        push(obj);
        res.send('404');
    }

});

function push(data) {
    ref.set(data);

    names.set({});
    for(var i = 0; i < data.length; i++) {
        names.child(data[i].id).set(data[i]);
    }
}

module.exports = router;