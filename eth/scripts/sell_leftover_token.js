// Generated by CoffeeScript 2.3.0
(function() {
  var BETOKEN_ADDR, BetokenFund, TOKENS, TOKEN_FACTORY_ADDR, TestTokenFactory, betoken, tokenFactory;

  BetokenFund = artifacts.require("BetokenFund");

  TestTokenFactory = artifacts.require("TestTokenFactory");

  BETOKEN_ADDR = "0x5910d5ABD4d5fD58b39957664Cd9735CbfE42bF0";

  TOKEN_FACTORY_ADDR = "0x76fc4b929325D04f5e3F3724eFDDFB45B52d3160";

  tokenFactory = TestTokenFactory.at(TOKEN_FACTORY_ADDR);

  betoken = BetokenFund.at(BETOKEN_ADDR);

  TOKENS = ["ETH", "ABT", "AE", "APPC", "BAT", "BBO", "BLZ", "ELEC", "ELF", "ENJ", "IOST", "KNC", "LBA", "LINK", "MANA", "MOT", "OMG", "PAL", "POLY", "RCN", "RDN", "REQ", "SNT", "STORM", "ZIL", "COFI", "WINGS", "WABI", "MDS", "LEND", "PAY", "BNT", "TOMO"];

  module.exports = function(callback) {
    var i, len, results, token;
    results = [];
    for (i = 0, len = TOKENS.length; i < len; i++) {
      token = TOKENS[i];
      results.push(tokenFactory.getToken(token).then(function(_addr) {
        console.log(`${token}: ${_addr}`);
        return betoken.sellLeftoverToken(_addr);
      }));
    }
    return results;
  };

}).call(this);