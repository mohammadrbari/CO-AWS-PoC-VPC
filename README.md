## Steps
 1.  Create **CO-PoC-VPC** with **10.252.0.0/20** and **100.64.0.0/24** CIDR blocks <br> 
 2.  Create **8x Private, 2x Public and 4x MGMT Subnets** in two Availability Zones.<br>
 3.  Create 3x **Routing Tables** and associate them with **Private**, **Public** and **MGMT** subnets <br> 
 4.  Create 1x **Internet Gateway** for Public Subnets <br> 
 5.  Create 1x **Elastic IPs (EIP)** to use in NAT Gateway <br>
 5.1 Create 1x **NAT Gateway** for Private Subnets  <br>
 6.  Add **Default Route** to route table CO-PoC-Public towards IGW <br>
 6.1 Add **Default Route** to route table CO-PoC-Private towards NATGW <br>
 7.  Create **VPN Gateway** as site to site VPN    
 
## Key Notes
 
***count -*** The number of identical resources to create. Here, **count** parameter is being used to create two subnets.  **count = 2** could be used, however what if in future another subnet required in the third AZ. Therefore, **length** function with **count** is better option. <br>

***length-*** determines the length of a given list, map, or string. In our case, length of the variable called **"azs"** is 2 (eu-west-2a and eu-west-2b), so two subnets are created. If we add one more AZ to the list then count will become 3 and three public subnets will be created. For Private Subnets (as its more than one subnet per AZ) length of the vairable used "poc-private-subnets" where number of subnets are defined.   <br>

***element-*** retrieves a single element from a list. In our example, we have a variable called "poc-public-subnets" with two subnets (list). By using **element** function, we are instructing Terraform to pick the subnet CIDR one by one in a loop. <br>

***tag Name-*** Let's take a look at the ***Subnet Name*** tag, for **"tag Name"**, we are using _**${count.index}**_ otherwise it will have a same tag for all subnets. We have used **count.index** to get the index value of each “iteration” in the “loop”. <br>


## Design 

