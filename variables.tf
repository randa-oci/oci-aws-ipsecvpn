############################
#  OCI Tenancy Credentials #
############################
variable "tenancy_ocid" {
  description = "User Tenancy OCID"
}

variable "compartment_ocid" {
  description = "User Compartment OCID"
}

variable "region" {
  description = "User Region Value"
}

variable "user_ocid" {
  description = "User OCID"
}

variable "fingerprint" {
  description = "User Private Key Fingerprint"
}

variable "private_key_path" {
  description = "User Private Key Path"
}

variable "ssh_public_key" {
  description = "SSH Public Key String"
}

############################
# OCI Variables  #
############################

variable "IaC_VCN_name" {
  description = "IaC VCN Name"
  default     = "IaC_VCN"
}

variable "IaC_VCN_CIDR" {
  description = "VCN CIDR"
}

variable "IaC_VCN_subnet_display_name" {
  description = "Compute Subnet Name"
  default     = "IaC_VCN_subnet"
}

variable "IaC_VCN_subnet" {
  description = "Compute Subnet CIDR"
}

variable "IaC_dns_label" {
  description = "IaC DNS Label"
  default     = "IaC"
}

variable "internet_gateway_name" {
  description = "OCI Internet Gateway Name"
  default     = "IGW"
}

variable "IaC_VCN_route_table" {
  description = "IaC VCN Route Table Name"
  default     = "IaC_VCN_route_table"
}

variable "security_policy_name" {
  description = "OCI Security Policy Name"
  default     = "IaC_Security_List"
}

variable "oci_cpe_name" {
  description = "CPE Name"
  default     = "IaC_CPE"
}

variable "oci_drg_name" {
  description = "IaC_DRG"
  default     = "IaC_DRG"
}

variable "ipsec_connection_name" {
  description = "IPSEC_to_AWS"
  default     = "IPSEC_to_AWS"
}

############################
# AWS Variables  #
############################

variable "aws_region" {
  description = "AWS Region Name"
}

variable "aws_profile" {
  description = "AWS Profile"
}

variable "IaC_VPC_CIDR" {
  description = "AWS VPC CIDR"
}

variable "IaC_VPC_subnet" {
  description = "AWS IaC VPC Subnet"
}

############################
# VPN Variables  #
############################

variable "shared_secret_1" {
  description = "Tunnel 1 Shared Secret"
}

variable "shared_secret_2" {
  description = "Tunnel 2 Shared Secret"
}
