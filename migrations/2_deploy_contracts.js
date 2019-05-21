const Recipe = artifacts.require("MyRecipe");
const fs = require('fs');

module.exports = function(deployer) {

    deployer.deploy(Recipe)
    .then(() => {
        let config = {
            localhost: {
                url: 'http://localhost:7545',
                appAddress: Recipe.address
            }
        }
        fs.writeFileSync(__dirname + '/../build/ui-schema.json',JSON.stringify(config, null, '\t'), 'utf-8');
    });
}