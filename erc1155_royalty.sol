// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.1/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.7.1/access/Ownable.sol";

contract MyToken is ERC1155, Ownable {
    uint256[] supplies = [10, 15, 20];
    uint256[] minting = [0, 0, 0];
    uint256[] rate = [0.01 ether, 0.01 ether, 0.01 ether];

    uint96 royaltyfee;
    string public contractURI;
    address royaltyReceiver;
    constructor(uint96 _royaltyfee, string memory _contractURI)
        ERC1155("https://ipfs.filebase.io/ipfs/QmTYqvXFk4LcA9pzeUxFd9p4vrc8dh5Xk8P6Y4oX3dtR2F")
    {
        royaltyfee=_royaltyfee;
        contractURI=_contractURI;
        royaltyReceiver=msg.sender;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(uint256 id, uint256 amount)
        public
        payable
    {
        uint256 index;
        require(id<=supplies.length, " Token does not exit");
        require(id!=0, "Token does not exit");
        _mint(msg.sender, id, amount, "");
        index = id - 1;
        require(minting[index] + amount <= supplies[index], " insufficient token");
        minting[index]+= amount;
        require(msg.value >= amount * rate[index], "Not enough fee");
    }

    function withdraw() public payable onlyOwner{
        require(address(this).balance > 0, " balance is not enough");
        payable(owner()).transfer(address(this).balance);

    }

    
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount){
        return (royaltyReceiver, calculateRoyalty(_salePrice));

    }

    function calculateRoyalty(uint256 _salePrice) view public returns (uint256){
        return (_salePrice/1000) * royaltyfee;

    }

    function setRoyaltyinfo(address _receiver, uint96 _royaltyfee) public onlyOwner{
        royaltyReceiver = _receiver;
        royaltyfee= _royaltyfee;
        
    }

    function setContractURI(string calldata _contractURI) public onlyOwner{
        contractURI = _contractURI;
        
    }


    



}
