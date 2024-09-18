// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InheritanceDistributingSystem {
    address public owner;
    uint256 public totalPool;
    
    struct Person {
        address wallet;
        uint256 percentage;
    }
    
    Person[] public persons;

    constructor() {
        owner = msg.sender;
    }

    // ใส่เงินเข้ากองกลาง
    function putMoneyIntoPool() public payable {
        require(msg.value > 0, "Must send some ether");
        totalPool += msg.value;
    }

    // ดูยอดเงินในกองกลาง
    function viewPoolBalance() public view returns (uint256) {
        return totalPool;
    }

    // เพิ่มหรือลบผู้รับมรดก
    function addPerson(address _wallet, uint256 _percentage) public onlyOwner {
        persons.push(Person(_wallet, _percentage));
    }
    
    function removePerson(uint256 index) public onlyOwner {
        require(index < persons.length, "Invalid index");
        persons[index] = persons[persons.length - 1];
        persons.pop();
    }
    
    // ดูข้อมูลผู้รับมรดก
    function viewPerson(uint256 index) public view returns (address, uint256) {
        require(index < persons.length, "Invalid index");
        Person memory person = persons[index];
        return (person.wallet, person.percentage);
    }

    // แจกจ่ายมรดก
    function distributeInheritance() public onlyOwner {
        require(totalPool > 0, "No money to distribute");
        for (uint256 i = 0; i < persons.length; i++) {
            uint256 amount = (totalPool * persons[i].percentage) / 100;
            payable(persons[i].wallet).transfer(amount);
        }
        totalPool = 0;
    }

    // เช็คว่าผู้เรียกใช้เป็นเจ้าของหรือไม่
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // ฟังก์ชัน keep alive
    function keepAlive() public onlyOwner {
        // Logic to keep the contract alive can go here, e.g., resetting a timer
    }
}
