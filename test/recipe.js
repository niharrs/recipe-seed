const Test = require('./testConfig.js');
const truffleAssert = require('truffle-assertions');

contract('Smart Contract Recipe Tests', async (accounts) => {

  let config;
  before('setup contract', async () => {
    config = await Test.Config(accounts);
  });

  /****************************************************************************************/
  /* Operations and Settings                                                              */
  /****************************************************************************************/

  it(`can add external document`, async function () {

    // Add document
    const inputIpfsHash = 'QmW6VHT5P4HqjJ2sZ3UiZbMvfDVEZcpFD54VXT3o8FPRQE';

    // Convert strings to bytes32
    let ipfsHashBytes = config.helpers.getBytes32FromIpfsHash(inputIpfsHash);
    let mimeTypeBytes = config.helpers.getBytes32FromString('image/png');

    // Add document to Smart Contract
    await config.recipeApp.updateExternalDoc(ipfsHashBytes, mimeTypeBytes);

    // Fetch all docs from Smart Contract
    let docs = await config.recipeApp.getExternalDocs.call();

    // Check if first document hash matches input document hash
    let outputIpfsHash = config.helpers.getIpfsHashFromBytes32(docs[0]);
    assert.equal(inputIpfsHash, outputIpfsHash, 'Incorrect document hash');
  });

  it(`can update Smart Page config hash`, async function () {

    // Add document
    const inputIpfsHash = 'QmW6VHT5P4HqjJ2sZ3UiZbMvfDVEZcpFD54VXT3o8FPRQE';

    // Convert strings to bytes32
    let ipfsHashBytes = config.helpers.getBytes32FromIpfsHash(inputIpfsHash);
    await config.recipeApp.updateSmartPageConfig(ipfsHashBytes);
    let smartPageConfig = await config.recipeApp.getSmartPageConfig.call();

    // Check if config hash matches input config hash
    let outputIpfsHash = config.helpers.getIpfsHashFromBytes32(smartPageConfig);
    assert.equal(inputIpfsHash, outputIpfsHash, 'Incorrect Smart Page config hash');
  });


  // Since this test hits "revert", it causes nonce problems. Run it as the last test.
  it(`rejects invalid document hash`, async function () {

    // Add document
    const inputIpfsHash = '';

    // Convert strings to bytes32
    let ipfsHashBytes = config.helpers.getBytes32FromIpfsHash(inputIpfsHash);
    let mimeTypeBytes = config.helpers.getBytes32FromString('image/png');
    let error = null;

    // when, then
    await truffleAssert.reverts(
      config.recipeApp.updateExternalDoc(ipfsHashBytes, mimeTypeBytes),
      'revert Invalid document hash'
    );
  });



});