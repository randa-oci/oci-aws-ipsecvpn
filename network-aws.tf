# ------ Create AWS Customer Gateway
resource "aws_customer_gateway" "IaC_CGW" {
  bgp_asn    = 31898
  ip_address = "1.1.1.1"
  type       = "ipsec.1"
  tags = {
    Name = "IaC_CGW"
  }
}

# Create a VPC
resource "aws_vpc" "IaC_VPC" {
  cidr_block = var.IaC_VPC_CIDR
  tags = {
    Name = "VPC_to_OCI"
  }
}

# Create a subnet
resource "aws_subnet" "IaC_Subnet" {
  vpc_id            = aws_vpc.IaC_VPC.id
  cidr_block        = var.IaC_VPC_subnet
}

# Create a Network ACL
resource "aws_network_acl" "IaC_Network_ACL" {
  vpc_id         = aws_vpc.IaC_VPC.id
  subnet_ids     = [aws_subnet.IaC_Subnet.id]
}

# Create a Network ACL Egress Rule
resource "aws_network_acl_rule" "IaC_Network_ACL_egress" {
    network_acl_id = aws_network_acl.IaC_Network_ACL.id
    rule_number    = 100
    protocol       = "-1"
    rule_action    = "allow"
    cidr_block     = "0.0.0.0/0"
    from_port      = 0
    to_port        = 0
    egress         = true
  }

# Create a Network ACL SSH Rule
resource "aws_network_acl_rule" "IaC_Network_ACL_SSH" {
    network_acl_id = aws_network_acl.IaC_Network_ACL.id
    rule_number    = 100
    protocol       = "6" 
    rule_action    = "allow"
    cidr_block     = var.IaC_VCN_CIDR
    from_port      = 22
    to_port        = 22
    egress         = false
  }

# Create a Network ACL ICMP Rule
resource "aws_network_acl_rule" "IaC_Network_ACL_ICMP" {
    network_acl_id = aws_network_acl.IaC_Network_ACL.id
    rule_number    = 101
    protocol       = "1"
    rule_action    = "allow"
    cidr_block     = var.IaC_VCN_CIDR
    from_port      = -1
    to_port        = -1
    icmp_code      = -1
    icmp_type      = -1
    egress         = false
  }

# Create a Network Security Group
resource "aws_security_group" "IaC_NSG" {
  name        = "IaC_NSG"
  description = "NSG for IaC"
  vpc_id      = aws_vpc.IaC_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.IaC_VCN_CIDR]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.IaC_VCN_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a Route table
resource "aws_route_table" "IaC_route_table" {
  vpc_id            = aws_vpc.IaC_VPC.id
    tags = {
    Name = "Route Table to OCI"
  }
}

#Create VPC Route rule
resource "aws_route" "IaC_Route_to_OCI" {
  route_table_id         = aws_route_table.IaC_route_table.id
  destination_cidr_block = var.IaC_VCN_CIDR
  gateway_id             = aws_vpn_gateway.IaC_vpn_gateway.id
}

# Associate route table to IaC Subnet
resource "aws_route_table_association" "IaC_route_table_association" {
  subnet_id      = aws_subnet.IaC_Subnet.id
  route_table_id = aws_route_table.IaC_route_table.id
}

# Create a Virtual Private Gateway
resource "aws_vpn_gateway" "IaC_vpn_gateway" {
  vpc_id = aws_vpc.IaC_VPC.id
  tags = {
    Name = "VPN-Gateway to OCI"
  }
}

# Attach the VPC to the VPN gateway
resource "aws_vpn_gateway_attachment" "IaC_vpn_gateway_attachment" {
  vpc_id          = aws_vpc.IaC_VPC.id
  vpn_gateway_id  = aws_vpn_gateway.IaC_vpn_gateway.id
}

# Create a Site to Site VPN connection
resource "aws_vpn_connection" "S2S_VPN_to_OCI" {
  customer_gateway_id    = aws_customer_gateway.IaC_CGW.id
  vpn_gateway_id         = aws_vpn_gateway.IaC_vpn_gateway.id
  type                   = "ipsec.1"
  tunnel1_inside_cidr    = "169.254.150.224/30"
  tunnel2_inside_cidr    = "169.254.150.228/30"
  tunnel1_preshared_key  = var.shared_secret_1
  tunnel2_preshared_key  = var.shared_secret_2
  tags = {
    Name = "S2S_VPN_to_OCI"
  }
}

# ------ Create New AWS Customer Gateway
resource "aws_customer_gateway" "New_IaC_CGW" {
  bgp_asn    = 31898
  ip_address = "${data.oci_core_ipsec_connection_tunnels.aws_ip_sec_connection_tunnels.ip_sec_connection_tunnels[0].vpn_ip}"
  type       = "ipsec.1"
  tags = {
    Name = "New_IaC_CGW"
  }
}
