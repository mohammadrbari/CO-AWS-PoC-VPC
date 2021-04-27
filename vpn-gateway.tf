# Customer Gateway
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65301
  ip_address = "51.149.9.34"
  type       = "ipsec.1"

  tags = {
    Name = "CO-DC01-CGW01"
  }
}

# VPN Gateway
resource "aws_vpn_gateway" "vgw" {
  amazon_side_asn = "64513"
    tags = {
    Name = "CO-DC01-VGW01"
  }
}

resource "aws_vpn_connection" "s2svpn" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
 tags = {
   Name = "CO-DC01-S2S-01"
 }
}

# VPN Gateways attachment with VPC
resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = aws_vpc.co-poc-vpc.id
  vpn_gateway_id = aws_vpn_gateway.vgw.id
}