// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./NFTMinter.sol";

contract Market is Ownable, NFTMinter {

    mapping (address => uint) addressToAmount;
    uint currentAmount = 0;
    bool isCompleted = false;

    uint immutable someLimit;
    uint immutable deadline;
    address immutable randomContractAddress;

    event NFTMinted(address indexed enjoyer, address NFT, uint tokenID);

    constructor (
        uint _someLimit, 
        uint _deadline, 
        address _rndAddress,
        address _bronze,
        address _silver,
        address _gold
    ) NFTMinter(_bronze, _silver, _gold) {
        someLimit = _someLimit;
        deadline = _deadline;
        randomContractAddress = _rndAddress;
    }

    modifier afterDeadline() {
        require(deadline > block.timestamp, "Deadline must be greater than current block timestamp");
        _;
    }

    modifier notCompleted() {
        require(!isCompleted, "Contract is already completed");
        _;
    }

    modifier completed() {
        require(isCompleted, "Contract is not completed yet");
        _;
    }
    
    receive() external payable {
        _accept(msg.sender, msg.value);
        _tryComplete();
    }

    fallback() external payable {
        _accept(msg.sender, msg.value);
        _tryComplete();
    }

    function withdraw() afterDeadline external {
        _tryComplete();
        _decline(msg.sender);
    }

    function mint() afterDeadline completed external {
        uint tokenID;
        address NFTAddr;
        (NFTAddr, tokenID) = _mintForAmount(msg.sender, _spendAmount(msg.sender));
        emit NFTMinted(msg.sender, NFTAddr, tokenID);
    }

    function _accept(address _sender, uint _amount) notCompleted internal {
        _accrueAmount(_sender, _amount);
    }

    function _decline(address _sender) internal notCompleted returns (uint) {
        uint amount = _spendAmount(_sender);
        _sendEther(_sender, amount);

        return amount;
    }

    function _accrueAmount(address _sender, uint _amount) private returns(uint) {
        addressToAmount[_sender] += _amount;
        currentAmount += _amount;

        return currentAmount;
    }

    function _spendAmount(address _sender) private returns(uint) {
        uint amount = addressToAmount[_sender];
        require(amount > 0, "Amount must be greater 0");
        delete addressToAmount[_sender];
        currentAmount -= amount;

        return amount;
    }

    function _sendEther(address _sender, uint _amount) private {
        payable(_sender).transfer(_amount);
    }

    function _tryComplete() internal {
        if (currentAmount > someLimit && deadline > block.timestamp) {
            _complete();
        }
    }

    function _complete() internal {
        _sendEther(randomContractAddress, currentAmount);
        isCompleted = true;
    }
}
