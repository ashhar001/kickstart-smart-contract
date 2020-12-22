const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');

const compiledFactory = require('./build/CampaignFactory.json');

const provider = new HDWalletProvider(
    'floor wedding mobile input wire lounge lend matter camp mouse volcano onion',
    'https://rinkeby.infura.io/v3/f2bcf7566f54469b8bbd1388820ac05f '
);

const web3 = new Web3(provider);

const deploy = async () => {

    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))  //interface here is ABI
        .deploy({ data: compiledFactory.bytecode })
        .send({ gas: '1000000' , from: accounts[0] });

    
    console.log('Contract Deployed to', result.options.address);
};

deploy();