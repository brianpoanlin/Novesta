/**
 * Created by Poppro on 9/23/17.
 */
/**
 * Created by Poppro on 9/23/17.
 */
var admin = require("firebase-admin");
var request = require("request")
var parseJSON = require('request-parse-json');

var url = "https://api.coinmarketcap.com/v1/ticker/?limit=100";

//connect to firebase

var db = admin.database();

var ref = db.ref("master_crypto");
var names = db.ref("name_crypto");
var history = db.ref("history_crypto");

/* GET users listing. */
this.updateDB = function() {
    //grab data
    request({
        method : 'GET',
        url : url
    }, parseJSON(next)); // Pass err, response, parsed body and raw body to next

    function next(err, response, repository, body) {
        var obj = JSON.parse(body);
        push(obj);
    }
};

function push(data) {
    for(var i = 0; i < data.length; i++) {
        if(data[i].id == 'bitcoin') {
            names.child(data[i].id).set(data[i]);
            ref.child('0').set(data[i]);
        }
        if(data[i].id == 'ethereum') {
            names.child(data[i].id).set(data[i]);
            ref.child('1').set(data[i]);
        }
        if(data[i].id == 'bitcoin-cash') {
            names.child(data[i].id).set(data[i]);
            ref.child('2').set(data[i]);
        }
        if(data[i].id == 'ripple') {
            names.child(data[i].id).set(data[i]);
            ref.child('3').set(data[i]);
        }
        if(data[i].id == 'dash') {
            names.child(data[i].id).set(data[i]);
            ref.child('4').set(data[i]);
        }
        if(data[i].id == 'litecoin') {
            names.child(data[i].id).set(data[i]);
            ref.child('5').set(data[i]);
        }
        if(data[i].id == 'nem') {
            names.child(data[i].id).set(data[i]);
            ref.child('6').set(data[i]);
        }
        if(data[i].id == 'iota') {
            names.child(data[i].id).set(data[i]);
            ref.child('7').set(data[i]);
        }
        if(data[i].id == 'steem') {
            names.child(data[i].id).set(data[i]);
            ref.child('8').set(data[i]);
        }
        if(data[i].id == 'ethereum-classic') {
            names.child(data[i].id).set(data[i]);
            ref.child('9').set(data[i]);
        }
        if(data[i].id == 'neo') {
            names.child(data[i].id).set(data[i]);
            ref.child('10').set(data[i]);
        }
        if(data[i].id == 'omisego') {
            names.child(data[i].id).set(data[i]);
            ref.child('11').set(data[i]);
        }
        if(data[i].id == 'bitconnect') {
            names.child(data[i].id).set(data[i]);
            ref.child('12').set(data[i]);
        }
        if(data[i].id == 'lisk') {
            names.child(data[i].id).set(data[i]);
            ref.child('13').set(data[i]);
        }
        if(data[i].id == 'qtum') {
            names.child(data[i].id).set(data[i]);
            ref.child('14').set(data[i]);
        }
        if(data[i].id == 'zcash') {
            names.child(data[i].id).set(data[i]);
            ref.child('15').set(data[i]);
        }
        if(data[i].id == 'tether') {
            names.child(data[i].id).set(data[i]);
            ref.child('16').set(data[i]);
        }
        if(data[i].id == 'stratis') {
            names.child(data[i].id).set(data[i]);
            ref.child('17').set(data[i]);
        }
        if(data[i].id == 'waves') {
            names.child(data[i].id).set(data[i]);
            ref.child('18').set(data[i]);
        }
        if(data[i].id == 'ark') {
            names.child(data[i].id).set(data[i]);
            ref.child('19').set(data[i]);
        }


        /*console.log(names[data[i].id]);
        if(names.child(data[i].id) != undefined) {
            names.child(data[i].id).child('market_limit').set(50000);
        }*/
    }

    for(var i = 0; i < 20; i++) {
        ref.child(i).child('market_limit').set(50000);
    }
}
