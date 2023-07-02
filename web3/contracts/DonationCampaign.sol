// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Donation Campaign contract
contract DonationCampaign {
    struct Campaing {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaing) public campaigns;

    uint256 public numberOfCampaigns = 0; // Number of campaigns

    // Create a new campaign
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaing storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "Deadline is in the past"); // Check if the deadline is in the past

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++; // Increment the number of campaigns

        return numberOfCampaigns - 1; // Return the id of the campaign
    }
    // Donate to a campaign
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value; // Get the amount of the donation

        Campaing storage campaign = campaigns[_id]; // Get the campaign

        campaign.donators.push(msg.sender); // Add the donator to the campaign

        campaign.donations.push(amount); // Add the donation to the campaign

        (bool sent, ) = payable(campaign.owner).call{value: amount}(""); // Send the donation to the owner of the campaign

        if (sent) {
            campaign.amountCollected += amount; // Add the amount to the amount collected
        }
    }
    // Get all donators and donations for a campaign
    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    // Get all campaigns
    function getCampaigns() public view returns (Campaing[] memory) {
        Campaing[] memory allCampaigns = new Campaing[](numberOfCampaigns); // Create a new dynamic array
        // Loop through all the campaigns
        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaing storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        // Return the array
        return allCampaigns;
    }
}
