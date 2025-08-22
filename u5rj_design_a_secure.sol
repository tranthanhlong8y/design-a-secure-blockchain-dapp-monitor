pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract SecureBlockchainMonitor {

    // Mapping of monitored blockchain nodes
    mapping (address => Node) public nodes;

    // Event emitted when a new node is added
    event NewNodeAdded(address indexed nodeAddress);

    // Event emitted when a node is removed
    event NodeRemoved(address indexed nodeAddress);

    // Event emitted when a node's status is updated
    event NodeStatusUpdated(address indexed nodeAddress, bool status);

    // Struct to represent a monitored node
    struct Node {
        address nodeAddress;
        bool status; // True if the node is online, False if offline
        uint256 lastUpdate; // Timestamp of the last status update
    }

    // Only the owner can add or remove nodes
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Add a new node to the monitor
    function addNode(address _nodeAddress) public onlyOwner {
        nodes[_nodeAddress] = Node(_nodeAddress, true, block.timestamp);
        emit NewNodeAdded(_nodeAddress);
    }

    // Remove a node from the monitor
    function removeNode(address _nodeAddress) public onlyOwner {
        delete nodes[_nodeAddress];
        emit NodeRemoved(_nodeAddress);
    }

    // Update the status of a node
    function updateNodeStatus(address _nodeAddress, bool _status) public {
        Node storage node = nodes[_nodeAddress];
        require(node.nodeAddress != address(0), "Node not found");
        node.status = _status;
        node.lastUpdate = block.timestamp;
        emit NodeStatusUpdated(_nodeAddress, _status);
    }

    // Get the status of a node
    function getNodeStatus(address _nodeAddress) public view returns (bool) {
        Node storage node = nodes[_nodeAddress];
        require(node.nodeAddress != address(0), "Node not found");
        return node.status;
    }

    // Get the list of all monitored nodes
    function getNodes() public view returns (address[] memory) {
        address[] memory nodeAddresses = new address[](nodes.length);
        for (uint256 i = 0; i < nodes.length; i++) {
            nodeAddresses[i] = nodes[i].nodeAddress;
        }
        return nodeAddresses;
    }
}