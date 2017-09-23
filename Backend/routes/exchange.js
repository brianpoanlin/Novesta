/**
 * Created by Poppro on 9/23/17.
 */
var express = require('express');
var router = express.Router();
var admin = require("firebase-admin");
var fs = require('fs');
var request = require("request")

var url = "https://api.coinmarketcap.com/v1/ticker/";

var db = admin.database();

var ref = db.ref("master_crypto");

/* GET users listing. */
router.get('/', function(req, res, next) {
     ref.on("value", function(snapshot) {
     res.send(snapshot.val());
     }, function (errorObject) {
     console.log("The read failed: " + errorObject.code);
     });

});

module.exports = router;