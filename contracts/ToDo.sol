// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.28;

contract ToDo {
    address private owner;

    struct ToDoList{
        string title;
        string ownerAddress;
    }

    ToDoList[] private ToDos;

    constructor(){
        owner = msg.sender;
    }

    modifier ownerModifier{
        require(msg.sender == owner, "You're not authorized");
        _;
    }


    function addToDo(string memory _title, string memory _ownerAddress) public ownerModifier{
        ToDos.push(ToDoList(_title, _ownerAddress));
    }

    function fetchToDo() public view returns(ToDoList[] memory ) {
        return ToDos;
    }


   function updateToDo(uint256 _index, string memory _newTitle, string memory _newOwnerAddress) public ownerModifier{
        require(_index < ToDos.length, "No todo with such index found");
        
        ToDos[_index].title = _newTitle;
        ToDos[_index].ownerAddress = _newOwnerAddress;
    }

    function removeToDo(uint256 _index) public ownerModifier{
        require(_index < ToDos.length, "No todo which such index found");
        for (uint256 i = 0; i < ToDos.length - 1; i++) {
            ToDos[i] =  ToDos[i + 1];
        }
        ToDos.pop();
    }


}