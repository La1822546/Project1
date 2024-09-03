// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PoolSystem {
    // เก็บยอดเงินทั้งหมดที่ถูกฝากในกองทุน
    uint256 public totalFunds;

    // เก็บข้อมูลยอดเงินที่แต่ละคนฝาก
    mapping(address => uint256) public balances;

    // เก็บสถานะว่าบุคคลนั้นๆ อยู่ในระบบหรือไม่
    mapping(address => bool) public persons;

    // ฟังก์ชันสำหรับฝากเงินเข้ากองทุน
    function deposit() public payable {
        require(msg.value > 0, "You need to deposit some money");

        // เพิ่มยอดเงินที่ฝากเข้ากองทุน
        totalFunds += msg.value;

        // เก็บยอดเงินที่ผู้ใช้ฝาก
        balances[msg.sender] += msg.value;
    }

    // ฟังก์ชันสำหรับดูยอดรวมของเงินในกองทุน
    function viewPoolBalance() public view returns (uint256) {
        return totalFunds;
    }

    // ฟังก์ชันสำหรับเพิ่มบุคคลในระบบ
    function addPerson(address _person) public {
        require(!persons[_person], "Person is already added");
        persons[_person] = true;
    }

    // ฟังก์ชันสำหรับลบบุคคลออกจากระบบ
    function removePerson(address _person) public {
        require(persons[_person], "Person does not exist");
        persons[_person] = false;
    }

    // ฟังก์ชันสำหรับตรวจสอบว่าบุคคลนั้นอยู่ในระบบหรือไม่
    function viewPerson(address _person) public view returns (bool) {
        return persons[_person];
    }

    // ฟังก์ชันสำหรับกระจายมรดก (เฉพาะในฟังก์ชันนี้เงินจะถูกแจกจ่ายไปยังที่อยู่ต่างๆ)
    function distributeInheritance(address payable[] memory heirs, uint256[] memory amounts) public {
        require(heirs.length == amounts.length, "Heirs and amounts length mismatch");
        
        for (uint256 i = 0; i < heirs.length; i++) {
            require(balances[msg.sender] >= amounts[i], "Insufficient balance to distribute");
            
            // โอนเงินให้ทายาท
            balances[msg.sender] -= amounts[i];
            heirs[i].transfer(amounts[i]);
        }

        // อัปเดตยอดรวมในกองทุน
        totalFunds -= getTotal(amounts);
    }

    // ฟังก์ชันช่วยคำนวณยอดรวมของ array
    function getTotal(uint256[] memory amounts) private pure returns (uint256 total) {
        for (uint256 i = 0; i < amounts.length; i++) {
            total += amounts[i];
        }
    }

    // ฟังก์ชันสำหรับยืนยันว่าบุคคลนั้นยังมีชีวิตอยู่
    function keepAlive() public view returns (string memory) {
        require(persons[msg.sender], "Person is not in the system");
        return "Person is alive!";
    }
}