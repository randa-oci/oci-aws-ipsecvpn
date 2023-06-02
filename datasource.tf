# Get the New AWS CGW IP 
data "oci_core_ipsec_connection_tunnels" "aws_ip_sec_connection_tunnels" {
    ipsec_id = oci_core_ipsec.aws_ipsec_connection.id
}

# Get Admin public IP
data "http" "public_ip" {
  url = "https://api.ipify.org?format=text"
}
