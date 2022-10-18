// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "hardhat/console.sol";

// function xen() external pure returns(address){
//     return address("0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8");
// }

interface IXEN{
    function claimRank(uint256 term) external;
    function claimMintReward() external;
    function claimMintRewardAndShare(address other, uint256 pct) external;
    function balanceOf(address account) external view returns(uint256);
}

contract Get{
    IXEN private constant xen = IXEN(0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8);

    address owner;
    constructor(){
        owner = tx.origin;
    }
    function claimRank(uint256 i) external{
        xen.claimRank(i);
    }
    function claimMintRewardAndShare() external{
        // require(tx.origin == owner, "only owner can call this function");
        xen.claimMintRewardAndShare(tx.origin, 100);
        // selfdestruct(payable(owner));
    }
    function balanceOf() external view returns(uint256){
        return xen.balanceOf(address(this));
    }
}

contract BatchMinterV0{
    address owner;
    mapping(address =>mapping(uint256=>address[])) public userContract;
    uint256 n;
    constructor(){
        owner = tx.origin;
    }
    function batchClaim(uint256 _n, uint256 term) external{
        n = _n;
        // require(tx.origin == owner, "only owner can call this function");
        for(uint256 i = 0; i < n; i++){
            Get get = new Get();
            get.claimRank(term);
            userContract[owner][term].push(address(get));
        }
    }
    function batchRewardAndShare(uint256 term) external{
        for(uint j=0;j<n;j++){
            uint256 leng = userContract[owner][term].length;
            address addr = userContract[owner][term][leng-1];
            Get get = Get(addr);
            get.claimMintRewardAndShare();
            userContract[owner][term].pop();
            
        }
    }

}
