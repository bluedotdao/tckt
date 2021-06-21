//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.5;

import "./IERC1155.sol";
import "hardhat/console.sol";


contract Receptionist {
  IERC1155 token;
  
  constructor(address _tokenContractAddress) {
    token = IERC1155(_tokenContractAddress);
  }

  function checkIn(uint256 id, uint256 timestamp, bytes memory signature) public view returns (bool) {
  	bytes32 message = prefixed(keccak256(abi.encodePacked(id, timestamp, this)));
    address recovered = recoverSigner(message, signature);
    uint256 balance = token.balanceOf(recovered, id);
    if(balance > 0) {
    	
    }
    return true;
  }
   function isValidSignature(uint256 amount, bytes memory signature)
        internal
        view
        returns (address)
    {
        
    }

    /// All functions below this are just taken from the chapter
    /// 'creating and verifying signatures' chapter.

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    /// builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}
