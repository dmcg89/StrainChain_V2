pragma solidity ^0.5.0;

import "./TradeableERC721Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Token
 * @author OpenSeaCreatures Tutorial / Dani Roxberry
 * Token - a contract for my non-fungible tokens.
 */
contract Token is TradeableERC721Token {
  /// @author Drew McGowan / Ryan Smith
  /// @notice Generate an ERC721Token for strain
  /// @return Flask API generating metadata for token
  constructor(address _proxyRegistryAddress) TradeableERC721Token("Token", "TT", _proxyRegistryAddress) public {  }

  function baseTokenURI() public view returns (string memory) {
    return "https://flannel-backbacon-65587.herokuapp.com/api/token/";
  }
}