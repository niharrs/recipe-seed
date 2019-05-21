pragma solidity  >=0.4.24;

contract MyRecipe {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/




    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/




    /********************************************************************************************/
    /*                                       CONSTRUCTOR                                        */
    /********************************************************************************************/

    constructor() public 
    {
        setContractOwner(); // Required...do NOT delete

    }

    /********************************************************************************************/
    /*                                         FUNCTIONS                                        */
    /********************************************************************************************/






    /********************************************************************************************/
    /*                                           EVENTS                                         */
    /********************************************************************************************/





    /********************************************************************************************/
    /*                                       CONTRACT OWNER                                     */
    /********************************************************************************************/
    
    address private contractOwner;          // Account used to deploy contract

    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    function setContractOwner() internal {
        contractOwner = msg.sender;
    }


    /********************************************************************************************/
    /*                                         SMART PAGE                                       */
    /********************************************************************************************/
    bytes32 public smartPageConfig;         // Hash of SmartPage configuration

    function updateSmartPageConfig(bytes32 configHash) external requireContractOwner {
        require(configHash[0] != 0, "Invalid SmartPage Config hash");

        smartPageConfig = configHash;
    }

    function getSmartPageConfig() external view returns(bytes32) {
        return smartPageConfig;
    }

    /********************************************************************************************/
    /*                                    EXTERNAL DOCUMENT STORAGE                             */
    /********************************************************************************************/

    /* Recipes may use decentralized storage to store external docs. This code is provided as a convenience.  */


    struct ExternalDoc {
        bool exists;
        bytes32 docHash;  
        bytes32 mimeType;
        address owner;
    }

    mapping(bytes32 => ExternalDoc) public externalDocs;         
    bytes32[] public externalDocsLookup;    

    function updateExternalDoc(bytes32 docHash, bytes32 mimeType) external
    {
        require(docHash[0] != 0, "Invalid document hash");

        if (!externalDocs[docHash].exists) {
            externalDocs[docHash] = ExternalDoc ({
                                        exists: true,
                                        docHash: docHash,
                                        mimeType: mimeType,
                                        owner: msg.sender
                                    });        
            externalDocsLookup.push(docHash);    
            emit AddExternalDoc(docHash, mimeType, msg.sender);
        }
        else {
            externalDocs[docHash].docHash = docHash;
            externalDocs[docHash].mimeType = mimeType;
            emit UpdateExternalDoc(docHash, mimeType, msg.sender);
        }
    }
              
    function getExternalDoc(bytes32 docHash) external view returns(bytes32, address)
    {
        require(externalDocs[docHash].exists);
        return (externalDocs[docHash].mimeType, externalDocs[docHash].owner);
    }

    function getExternalDocs() external view returns(bytes32[] memory)
    {
        return externalDocsLookup;
    }
    
    event AddExternalDoc(bytes32 indexed docHash, bytes32 mimeType, address indexed owner);
    event UpdateExternalDoc(bytes32 indexed docHash, bytes32 mimeType, address indexed owner);

}   


// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/
library SafeMath {
/* Copyright (c) 2016 Smart Contract Solutions, Inc. */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
        return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
