terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
    }
  }
}

# ------ Initialize AWS Terraform provider
provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# ------ Initialize Oracle Terraform provider
provider "oci" {
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint  
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
}   
