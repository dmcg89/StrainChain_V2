pragma solidity ^0.5.0;

import "./TradeableERC721Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Token
 * Token - a contract for my non-fungible tokens.
 */
contract Token is TradeableERC721Token {
  constructor(address _proxyRegistryAddress) TradeableERC721Token("Token", "OSC", _proxyRegistryAddress) public {  }

  function baseTokenURI() public view returns (string memory) {
    return "https://opensea-creatures-api.herokuapp.com/api/creature/";
  }
}