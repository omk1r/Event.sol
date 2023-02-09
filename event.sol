// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
 
 contract  EventContract
 {
     struct Event{
         address organizer;
         string name;
         uint date;
         uint price;
         uint ticketCount;
         uint ticketRemain;
     }

 mapping(uint=>Event) public events;
 mapping(address=>mapping(uint=>uint)) public tickets;
 uint public nextId;

 function createEvent(string memory name,uint date,uint price,uint ticketCount) external {
     require(date>block.timestamp,"You can organize event for future");
     require(ticketCount>0,"You can organize event only if you create more than 0 tickets");

     events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
     nextId++;
 }

    function buyTicket(uint id,uint quantity) external payable 
    {
        require(events[id].date!=0,"This event does not exist");
        require(block.timestamp<events[id].date);
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity));
        require(_event.ticketRemain>=quantity,"Not enough Tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"This event does not exist");
        require(block.timestamp<events[id].date);
        require(tickets[msg.sender][id]>=quantity,"you do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
 }