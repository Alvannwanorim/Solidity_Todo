//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TodoList {
    //Variables 
    uint256 public _idUser;
    address private immutable i_contractOwner;

    address[] private creators;
    string[] private messages;
    uint256[] private messageId;

    //Types
    struct Todo{
        address account;
        uint256 userId;
        string message;
        bool isCompleted;
    }

    //Events 
    event TodoEvent (
        address indexed account,
        uint256 indexed userId,
        string message,
        bool isCompleted
    );
    mapping(address => Todo) public todoItems; 

    constructor(){
        i_contractOwner = msg.sender;
    }

    function inc() internal {
        _idUser++;
    }

    function createTodo(string calldata _message) external {
        inc();
        Todo storage todo = todoItems[msg.sender];
        todo.account = msg.sender;
        todo.message = _message; 
        todo.isCompleted = false;
        todo.userId = _idUser;

        creators.push(msg.sender);
        messages.push(_message);
        messageId.push(_idUser);
        emit TodoEvent(todo.account, _idUser, _message, todo.isCompleted);

    }

    function getCreatorData(address _creator) public view returns(address, uint256, string memory, bool){
        Todo memory todo = todoItems[_creator];
        return (
            todo.account,
            todo.userId,
            todo.message,
            todo.isCompleted
        );
    }

    function getCreators() public view returns(address[] memory) {
        return creators;
    }

    function getMessages() public view returns(string[] memory) {
        return messages;
    }

    function toggle(address _address) public {
        Todo storage todo = todoItems[_address];
        todo.isCompleted = !todo.isCompleted;
    }
}