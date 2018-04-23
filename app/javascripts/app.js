// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import charcoal_artifacts from '../../build/contracts/Charcoal.json'

// Charcoal is our usable abstraction, which we'll use through the code below.
var Charcoal = contract(charcoal_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;
var contractAddress;

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the Charcoal abstraction for use
    Charcoal.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Could not find any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0]; // Change index to select MetaMask wallet account

      self.getContractAddress();

      self.refreshBalance();
      self.refreshSupply();
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  refreshBalance: function() {
    var self = this;

    self.setStatus("Refreshing balance...");
    
    var char;
    Charcoal.deployed().then(function(instance) {
      char = instance;
      return char.balanceOf.call(account, {from: account});
    }).then(function(value) {
      var balance_element = document.getElementById("balance");
      balance_element.innerHTML = value.valueOf();
      self.setStatus("Refreshed balance");
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting balance, refer to log for details");
    });
  },

  refreshContractBalance: function() {
    var self = this;

    var char;
    Charcoal.deployed().then(function(instance) {
      char = instance;
      return char.balanceOf.call(contractAddress, {from: account});
    }).then(function(value) {
      var contract_balance_element = document.getElementById("contract-balance");
      contract_balance_element.innerHTML = value.valueOf();
      console.log(e);
      self.setStatus("Refreshed contract balance");
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error refreshing contract balance, refer to log for details");
    });
  },

  refreshSupply: function() {
    var self = this;

    var char;
    Charcoal.deployed().then(function(instance) {
      char = instance;
      return char.totalSupply.call(account, {from: account});
    }).then(function(value) {
      var supply_element = document.getElementById("supply");
      supply_element.innerHTML = value.valueOf();
    }).catch(function(e) {
      console.log(e);
    });
  },

  getContractAddress: function() {
    var self = this;

    self.setStatus("Retrieving Charcoal contract address... please wait");

    var char;
    Charcoal.deployed().then(function(instance) {
      char = instance;
      return char.contractAddress.call({from: account});
    }).then(function(address) {
      contractAddress = address;
      self.setStatus("Charcoal contract retrieval successful");
      self.refreshContractBalance();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error retrieving Charcoal contract address, refer to console log for details");
    });
  },

  payContract: function(amount) {
    var self = this;
    var address = contractAddress;

    self.setStatus("Initiating payment to contract... please wait");

    var char;
    Charcoal.deployed().then(function(instance) {
      char = instance;
      return char.transfer(address, amount, {from: account});
    }).then(function(result) {
      self.setStatus("Payment successful");
      self.refreshBalance();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error completing payment, refer to console log for details");
    });
  },

  transfer: function() {
    var self = this;

    var amount = parseInt(document.getElementById("amount").value);
    var recipient = document.getElementById("recipient").value;

    self.setStatus("Initiating transaction... please wait");

    var char;
    Charcoal.deployed().then(function(instance) {
      char = instance;
      return char.transfer(recipient, amount, {from: account});
    }).then(function() {
      self.setStatus("Transaction complete");
      self.refreshBalance();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending token, refer to console log for details");
    });
  }
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 Charcoal, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:7545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
  }

  App.start();
});
