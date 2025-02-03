// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

contract Charity {
    // setting public explicitly is best practice,
    //  but I think it's redundant
    uint public target;
    uint public totalContributed = 0;
    string public goal;
    address public owner;

    // I think a fixed sized array might cost less,
    // but using address[5] and then calling admins.push() errors

    address[] public admins = [
        owner
        // ,0x0000000000000000000000000000000000000000
    ];

    mapping(address => uint) public contributions;

    event DonationReceived(address indexed from, uint amount);
    event FundsTransferred(address indexed to, uint amount);
    event FundsWithdrawn(address indexed to, uint amount);
    event TargetReached(uint time, uint total);
    event AdminAdded(address indexed addr);
    // event ContractDeployed();

    constructor(uint _target, string memory _goal) {
        target = _target;
        goal = _goal;
        owner = msg.sender;
        // emit ContractDeployed();
    }

    // VIEW FUNCTIONS

    function getProgress() public view returns (uint) {
        // Maybe this is an overkill??

        // require(
        //     contributions[msg.sender] > 0,
        //     "You can only see progress after you have donated"
        // );
        uint progress = _calculatePercentage(target, totalContributed);
        return progress;
    }

    // HELPERS

    function _calculatePercentage(
        uint _target,
        uint _total
    ) private pure returns (uint) {
        return (_total / _target) * 100;
    }

    function _checkExists(
        address[] memory _arr,
        address _addr
    ) private pure returns (bool) {
        for (uint i = 0; i < _arr.length; i += 1) {
            if (_arr[i] == _addr) {
                return true;
            }
        }
        return false;
    }

    // OR (for larger datasets)

    // could declare a mappings in storage called exists,
    // address => bool, and if exists[_addr] = true, then it exists.
    // then to add to array, you check if the exists.
    // mapping(address => bool) exist;
    // address[] admins;

    // function _checkExists(address _addr) private view returns (bool) {
    //     return exist[_addr];
    // }

    // Then to add

    // function addNewAdmin(address _addr) private {
    //     if (!exist[_addr]) {
    //         exist[_addr] = true;
    //         admins.push(_addr);
    //     }
    // }

    // OR (could use Open Zeppelin Enumerable set, only ... it's verbose)

    // ADMIN ONLY

    // What if I create an admins array and then if any of
    // the addresses is passed, then they can access admin functions
    // e.g modifier isAdmin(address _addr)

    modifier isAdmin() // address _addr
    {
        // require(_checkExists(admins, _addr), "Admin only");
        require(msg.sender == owner, "Admin only");
        _;
    }

    function withdraw() public isAdmin {
        uint amount = address(this).balance;
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to withdraw");
        emit FundsWithdrawn(owner, amount);
    }

    function transfer(address _to, uint _amount) public isAdmin {
        require(
            _amount >= 0 && _amount <= address(this).balance,
            "Amount must be greater than 0 and less than balance"
        );
        (bool success, ) = payable(_to).call{value: _amount}("");
        require(success, "Transfer failed");
        emit FundsTransferred(_to, _amount);
    }

    function getBalance() public view isAdmin returns (uint) {
        return address(this).balance;
    }

    function addNewAdmin(address _addr) public isAdmin {
        require(admins.length <= 5, "Can have only 5 admins");
        admins.push(_addr);
        emit AdminAdded(_addr);
    }

    // GENERAL FUNCTIONS

    function donate() public payable {
        require(
            totalContributed < target,
            "Target reached. Thanks for your participation"
        );
        require(msg.value > 0, "You have to send some ether");
        contributions[msg.sender] += msg.value;
        totalContributed += msg.value;
        emit DonationReceived(msg.sender, msg.value);
        if (totalContributed >= target) {
            emit TargetReached(block.timestamp, totalContributed);
        }
    }

    function myContributions() public view returns (uint) {
        require(contributions[msg.sender] > 0, "You have not donated yet");
        return contributions[msg.sender];
    }
}

/**
 * TODO
 * 1. Create an admins array and map through to determin if an address is an admin
 *      Done
 */
