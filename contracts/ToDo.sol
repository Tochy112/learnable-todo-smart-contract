// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.2;

contract ToDo {
    address private owner;
    uint256 private todoCount;

    struct ToDoItem {
        uint256 id;
        string title;
        string description;
        address ownerAddress;
        bool completed;
        uint256 createdAt;
        uint256 updatedAt;
    }

    // Mapping for better data access - id to ToDoItem
    mapping(uint256 => ToDoItem) private todos;
    
    // Array of all todo IDs
    uint256[] private todoIds;

    // Events 
    event TodoAdded(uint256 indexed id, string title, address ownerAddress);
    event TodoUpdated(uint256 indexed id, string newTitle, address ownerAddress);
    event TodoCompleted(uint256 indexed id);
    event TodoRemoved(uint256 indexed id);
   

    constructor() {
        owner = msg.sender;
        todoCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier validTodoId(uint256 _id) {
        require(_id > 0 && _id <= todoCount && todos[_id].id == _id, "Invalid todo ID");
        _;
    }

   
    function addToDo(
        string memory _title, 
        string memory _description, 
        address _ownerAddress
    ) public onlyOwner returns (uint256) {
        require(bytes(_title).length > 0, "Title cannot be empty");
        
        todoCount++;
        
        // Create and store the new todo item
        todos[todoCount] = ToDoItem({
            id: todoCount,
            title: _title,
            description: _description,
            ownerAddress: _ownerAddress,
            completed: false,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        
        todoIds.push(todoCount);
        
        // Emit event
        emit TodoAdded(todoCount, _title, _ownerAddress);
        
        return todoCount;
    }


    function fetchAllToDos() public view returns (ToDoItem[] memory) {
        ToDoItem[] memory allTodos = new ToDoItem[](todoIds.length);
        
        for (uint256 i = 0; i < todoIds.length; i++) {
            allTodos[i] = todos[todoIds[i]];
        }
        
        return allTodos;
    }

    function fetchToDoById(uint256 _id) public view validTodoId(_id) returns (ToDoItem memory) {
        return todos[_id];
    }

    function updateToDo(
        uint256 _id, 
        string memory _newTitle, 
        string memory _newDescription, 
        address _newOwnerAddress
    ) public onlyOwner validTodoId(_id) {
        require(bytes(_newTitle).length > 0, "Title cannot be empty");
        
        todos[_id].title = _newTitle;
        todos[_id].description = _newDescription;
        todos[_id].ownerAddress = _newOwnerAddress;
        todos[_id].updatedAt = block.timestamp;
        
        emit TodoUpdated(_id, _newTitle, _newOwnerAddress);
    }

   
    function completeToDo(uint256 _id) public onlyOwner validTodoId(_id) {
        require(!todos[_id].completed, "Todo is already completed");
        
        todos[_id].completed = true;
        todos[_id].updatedAt = block.timestamp;
        
        emit TodoCompleted(_id);
    }

   
    function removeToDo(uint256 _id) public onlyOwner validTodoId(_id) {
        uint256 indexToRemove;
        bool found = false;
        
        for (uint256 i = 0; i < todoIds.length; i++) {
            if (todoIds[i] == _id) {
                indexToRemove = i;
                found = true;
                break;
            }
        }
        
        require(found, "Todo ID not found in the array");
        
        if (indexToRemove < todoIds.length - 1) {
            todoIds[indexToRemove] = todoIds[todoIds.length - 1];
        }
        todoIds.pop();
        
        delete todos[_id];
        
        emit TodoRemoved(_id);
    }

    function getTodoCount() public view returns (uint256) {
        return todoIds.length;
    }
}