pragma solidity ^0.4.17;

contract CampaignFactory{
    
    address[] public deployedCampaign;
    
    function createCampaign(uint minimum) public {
        
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaign.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns(address[]){
        
        return deployedCampaign;
    }
}


contract Campaign{
    
    struct Request{
        //These are values types
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount; //num of Yes Votes
        
        //This is reference type
        mapping(address => bool) approvals; //yes or no Votes
        
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    
    modifier restricted(){
        
        require(msg.sender == manager);
        _;
    }
    
    function Campaign(uint minimum, address creator) public {
        
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable{
        
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) public restricted{
        
        
        Request memory newRequest = Request({
            
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        
        Request storage request = requests[index];
        
        require(approvers[msg.sender]); // check wether user is a donator
        require(!request.approvals[msg.sender]);
        // require(!requests[index].approvals[msg.sender]); // check if it is already donated
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
        
        // requests[index].approvals[msg.sender] = true;   // marking that the person has voted
        // requests[index].approvalCount++;    // increasing the vote count
    }
    
    
    function finaliseRequest(uint index) public restricted{
        
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount/2));    // check wether more than 50% of the contributer approved
        require(!request.complete);
        
        request.recipient.transfer(request.value);  //transfer the amount to vendor or recipient
        request.complete = true;
        
        
    }
    
}