// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "hardhat/console.sol";

interface IXEN {
	function claimRank(uint term) external;
	function claimMintReward() external;
	function claimMintRewardAndShare(address other, uint256 pct) external;
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract BatchMinterV2 {
	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
	address private immutable original;
	address private immutable deployer;
	uint256 n;
	address private constant XEN = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;
	bytes32 byteCode;
	
	constructor() {
        original = address(this);
		deployer = msg.sender;
	}
	function claimRank(uint term) external {
		IXEN(XEN).claimRank(term);
	}
	function createAndClaim(uint256 _n, uint256 term) external {
		require(msg.sender == deployer, "only deployer can call this function");
		bytes memory miniProxy = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
        byteCode = keccak256(abi.encodePacked(miniProxy));  
		address proxy;
		for(uint i=n; i<n+_n; i++) {
	        bytes32 salt = keccak256(abi.encodePacked(msg.sender, i));
			assembly {
	            proxy := create2(0, add(miniProxy, 32), mload(miniProxy), salt)
			}
			console.log("contract===", proxy);
			BatchMinterV2(proxy).claimRank(term);
		}	
	}
	
	function claimMintRewardAndShare(address other, uint256 pct) external{
		require(msg.sender == original, "only original can call this function");
		IXEN(XEN).claimMintRewardAndShare(other, pct);
	}

    function proxyFor(address sender, uint i) public view returns (address proxy) {
        bytes32 salt = keccak256(abi.encodePacked(sender, i));
        proxy = address(uint160(uint(keccak256(abi.encodePacked(
                hex'ff',
                address(this),
                salt,
                byteCode
            )))));
	}

	function claimMintReward(uint256 _n) external {
		for (uint i=n; i<n+_n; i++) {
			address proxy = proxyFor(msg.sender, i);
			// address proxy = proxyFor(i);
			
			console.log("get contract===", proxy);

			BatchMinterV2(proxy).claimMintRewardAndShare(tx.origin, 100);
			
		}		
		n = n+_n;

	}

}