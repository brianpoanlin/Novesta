/**
 * Created by Poppro on 9/23/17.
 */
var admin = require("firebase-admin");
var request = require("request")
var parseJSON = require('request-parse-json');

var url = "https://api.coinmarketcap.com/v1/ticker/?limit=40";

//connect to firebase

var db = admin.database();

var history = db.ref("history_crypto");

/* GET users listing. */
this.updateDB = function() {
    var test = db.ref("master_crypto");
    var data;

    test.once("value", function(snapshot) {
        data = snapshot.val();
        push(data)
    }, function (errorObject) {
        console.log("The read failed: " + errorObject.code);
    });
};

function push(data) {

    /*history.set({});
    for(var i = 0; i < 20; i++) {
        history.child('c'+i).set({
            name : data[i].id
            //1 : data[i].price_usd
        });
    }*/

    //grab the snapshot to dermine current amount of vals
    var test = db.ref("history_crypto/c19");
    var s;
    test.once("value", function(snapshot) {
        s = Object.keys(snapshot.val()).length;
        for(var i = 0; i < 20; i++) {
            console.log(s);
            history.child('c'+i).child(s+'').set(data[i].price_usd);
        }
    }, function (errorObject) {
        console.log("The read failed: " + errorObject.code);
    });

    //update accordingly

}