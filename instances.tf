# EIP Association with Instance

#resource "aws_eip_association" "eip-assoc" {
#  instance_id = aws_instance.public-ec2.*.id
#  allocation_id = aws_eip.nat-eip.id
#
#}
#

# Network Interface

#resource "aws_network_interface" "public-nic" {
#
#  count = length(var.private-ip)
#  subnet_id = element(aws_subnet.poc-public-subnets.*.id, count.index)
#  private_ip = element(var.private-ip,count.index )
#
#  #security_groups = [aws_security_group.HTTPS.id]
#
#  tags = {
#    Name = "Public NIC-${count.index+1}"
#  }
#}
#
# TEST Spin up EC2 Instance in Public

#resource "aws_instance" "public-ec2" {
#  count = 1
#  ami = "ami-0fbec3e0504ee1970"
#  instance_type = var.instance_type
#  availability_zone = "eu-west-2a"
#  key_name = var.key_pairs
#  associate_public_ip_address = true
#
#  network_interface {
#    device_index = 0
#    network_interface_id = element (aws_network_interface.public-nic.*.id,count.index)
#
#  }
#
#  tags = {
#    Name = "TEST-EC2-PUBLIC"
#  }
#}