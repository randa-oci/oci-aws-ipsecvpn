# ------ Create OCI CPE
resource "oci_core_cpe" "aws_cpe" {
  compartment_id = var.compartment_ocid
  display_name   = var.oci_cpe_name
  ip_address     = aws_vpn_connection.S2S_VPN_to_OCI.tunnel1_address
}
# ------ Create OCI VCN 
resource "oci_core_vcn" "IaC_VCN" {
  cidr_block     = var.IaC_VCN_CIDR
  compartment_id = var.compartment_ocid
  display_name   = var.IaC_VCN_name
  dns_label      = var.IaC_dns_label
}
# ------ Create Security Policies
resource "oci_core_security_list" "security_policies" {
  compartment_id = var.compartment_ocid
  display_name   = var.security_policy_name
  vcn_id         = oci_core_vcn.IaC_VCN.id
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = var.IaC_VPC_CIDR
    tcp_options {
          min = 22
          max = 22
        }
  }
  ingress_security_rules {
    protocol = "6"
    source   = "172.16.0.0/16"
    tcp_options {
          min = 22
          max = 22
        }
    }
  ingress_security_rules {
    protocol = "6"
    source   =  "${data.http.public_ip.response_body}/32"
    tcp_options {
          min = 22
          max = 22
        }
    }
  ingress_security_rules {
    protocol = "1"
    source   = var.IaC_VPC_CIDR
  }
  ingress_security_rules {
    protocol = "1"
    source   = "172.16.0.0/16"
  }
}

# ------ Create OCI VCN Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = var.internet_gateway_name
  vcn_id         = oci_core_vcn.IaC_VCN.id
}
# ------ Create DRG on OCI 
resource "oci_core_drg" "IaC_DRG" {
  compartment_id = var.compartment_ocid
  display_name   = var.oci_drg_name
}
# ------ Create DRG VCN attachment
resource "oci_core_drg_attachment" "IaC_vcn_attachment" {
  vcn_id             = oci_core_vcn.IaC_VCN.id
  drg_id             = oci_core_drg.IaC_DRG.id
  display_name       = "AWS_VCN DRG Attachment"
}
# ------ Create VCN Route Table
resource "oci_core_route_table" "IaC_VCN_route_table" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.IaC_VCN.id
    display_name       = var.IaC_VCN_route_table
    route_rules {
        network_entity_id = oci_core_internet_gateway.internet_gateway.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
    route_rules {
        network_entity_id = oci_core_drg.IaC_DRG.id
        destination = var.IaC_VPC_CIDR
        destination_type = "CIDR_BLOCK"
    }
    route_rules {
        network_entity_id = oci_core_drg.IaC_DRG.id
        destination = "172.16.0.0/16"
        destination_type = "CIDR_BLOCK"
    }
}

# ------ Create Instance Subnet
resource "oci_core_subnet" "IaC_VCN_subnet" {
  cidr_block          = var.IaC_VCN_subnet
  display_name        = var.IaC_VCN_subnet_display_name
  dns_label           = var.IaC_dns_label
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.IaC_VCN.id
  dhcp_options_id     = oci_core_vcn.IaC_VCN.default_dhcp_options_id
  security_list_ids   = [oci_core_security_list.security_policies.id]
  route_table_id      = oci_core_route_table.IaC_VCN_route_table.id
}
# ------ Create Site-to-Site VPN
resource "oci_core_ipsec" "aws_ipsec_connection" {
  static_routes  = ["0.0.0.0/0"]
  compartment_id = var.compartment_ocid
  display_name   = var.ipsec_connection_name
  cpe_id         = oci_core_cpe.aws_cpe.id
  drg_id         = oci_core_drg.IaC_DRG.id
}

# Modify Tunnel 1 from static to BGP
resource "oci_core_ipsec_connection_tunnel_management" "bgp_ip_sec_connection_tunnel_1" {
    ipsec_id = oci_core_ipsec.aws_ipsec_connection.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.aws_ip_sec_connection_tunnels.ip_sec_connection_tunnels[0].id
    routing = "BGP"
      bgp_session_info {
        customer_bgp_asn = "64512"
        customer_interface_ip = "169.254.150.225/30"
        oracle_interface_ip = "169.254.150.226/30"
    }
    display_name = "Tunnel 1"
    shared_secret = var.shared_secret_1
    ike_version = "V2"
}

# Modify Tunnel 2 from static to BGP
resource "oci_core_ipsec_connection_tunnel_management" "bgp_ip_sec_connection_tunnel_2" {
    ipsec_id = oci_core_ipsec.aws_ipsec_connection.id
    tunnel_id = data.oci_core_ipsec_connection_tunnels.aws_ip_sec_connection_tunnels.ip_sec_connection_tunnels[1].id
    routing = "BGP"
      bgp_session_info {
        customer_bgp_asn = "64512"
        customer_interface_ip = "169.254.150.230/30"
        oracle_interface_ip = "169.254.150.229/30"
    }
    display_name = "Tunnel 2"
    shared_secret = var.shared_secret_2
    ike_version = "V2"
}