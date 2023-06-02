This repository configures the following:

- Site to Site VPN between OCI and AWS using the public Internet as underlay
- AWS: CGW, VPN Gateway, VPC, Subnet, Route Table, NACL and NSG
- OCI: CPE, DRG, VCN, IGW, Subnet, Route Table and security list.

Steps for implementing the configuration:

- Duplicate the terraform.tfvars.template and rename to terraform.tfvars
- In the new terraform tfvars file complete the "Oracle Variables", "AWS Variables" and "VPN Variables"
- Authenticate to AWS. For simplicity it is recommended to do it via the AWS Toolkit (requires installation)

After successfully performing the "terraform apply" the administrator must connect to the AWS Portal and modify the Site-to-Site VPN selecting the New IaC CGW".
This will be the last step for completing the connection.

At this point the administrator can create an EC2 and a compute instances in AWS and OCI. 

ICMP and SSH is enabled between AWS and OCI. 
SSH is enabled from the administrator public IP to OCI. 
