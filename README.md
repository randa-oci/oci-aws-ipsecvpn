This repository configures the following:

- SIte to Site VPN between OCI and AWS using the public Internet as underlay
- AWS: CGW, VPN Gateway, VPC, Subnet, Route Table, NACL and NSG
- OCI: CPE, DRG, VCN, IGW, Subnet, Route Table and security list.

After successfully performing the "terraform apply" the administrator must connect to the AWS Portal and modify the Site to Site VPN selecting the New IaC CGW".
This will be the last step for completing the connection.

At this point the administrator can create EC2 and compute instances in AWS and OCI. 
ICMP and SSH is enabled between AWS and OCI. Additionally SSH is enabled to OCI from the administartor public IP 
