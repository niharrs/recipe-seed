const Recipe = artifacts.require("MyRecipe");
const fs = require('fs');

module.exports = function(deployer) {

    deployer.deploy(Recipe)
    .then(() => {
        let schema = {
            "todo": null
        }

        fs.writeFileSync(__dirname + '/../build/ui-schema.json',JSON.stringify(shema, null, '\t'), 'utf-8');
    });
}