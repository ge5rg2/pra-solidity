// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

contract DischargedMilitary {
    address private issuerAddress;
    uint256 private idCount;
    mapping(uint8 => string) private armyType;

    struct Credential{
        // 순서
        uint256 id;
        // 발급자
        address issuer;
        // 병과 (육군,해군,공군,해병대)
        uint8 armyType;
        // 전역날짜
        string date;
    }

    mapping(address => Credential) private credentials;

    constructor() {
        issuerAddress = msg.sender;
        idCount = 1;
        armyType[0] = "Army";
        armyType[1] = "Navy";
        armyType[2] = "Air Force";
        armyType[3] = "Marine";
    }

    function claimCredential(address _alumniAddress, uint8 _armyType, string calldata _date) public returns(bool){
        require(issuerAddress == msg.sender, "Not Issuer");
				Credential storage credential = credentials[_alumniAddress];
        require(credential.id == 0);
        credential.id = idCount;
        credential.issuer = msg.sender;
        credential.armyType = _armyType;
        credential.date = _date;
        
        idCount += 1;

        return true;
    }

    function hash(uint256 _id, address _issuer, uint8 _armyType, string memory _date) pure internal returns(bytes32) {
    return keccak256(abi.encodePacked(_id,_issuer,_armyType,_date));
    }

    function getCredential(address _alumniAddress) public view returns (Credential memory){
        return credentials[_alumniAddress];
    }

}