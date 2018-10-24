var steem = require("@steemit/steem-js");

var wif = process.env.STEEM_WIF;
var username = process.env.STEEM_USERNAME;

//var url = 'https://this.piston.rocks'
//steem.api.setOptions({ url: url });

function main() {
    steem.broadcast.claimAccount(
        wif,
        username,
        '0.000 STEEM',
        [],
        function(
            err,
            result
        ) {
            console.log(err, result);
        }
    );
}

main()
