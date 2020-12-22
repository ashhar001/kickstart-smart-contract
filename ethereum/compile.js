const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');//fs is file system

const buildPath = path.resolve(__dirname, 'build'); //path to build folder in root directory
fs.removeSync(buildPath);   //delete the build folder

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf8');
const output = solc.compile(source,1).contracts;

fs.ensureDirSync(buildPath);


for(let contract in output){

    fs.outputJSONSync(
        path.resolve(buildPath, contract.replace(':', '') + '.json'),
        output[contract]
    );
}