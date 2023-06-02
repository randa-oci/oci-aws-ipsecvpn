This repository configures the following:

- Site to Site VPN between OCI and AWS using the public Internet as underlay
- AWS: CGW, VPN Gateway, VPC, Subnet, Route Table, NACL and NSG
- OCI: CPE, DRG, VCN, IGW, Subnet, Route Table and security list.
- ICMP and SSH is enabled between AWS and OCI. 
 -SSH is enabled from the administrator public IP to OCI. 

Steps for implementing the configuration:

- Duplicate the terraform.tfvars.template and rename to terraform.tfvars
- In the new terraform tfvars file complete the "Oracle Variables", "AWS Variables" and "VPN Variables"
- Authenticate to AWS. For simplicity it is recommended to do it via the AWS Toolkit (requires installation)

Create the Resources using the following commands:

- terraform init
- terraform plan
- terraform apply

After successfully performing the "terraform apply" the administrator must connect to the AWS Portal and modify the Site-to-Site VPN selecting the New IaC CGW".
This will be the last step for completing the connection.

At this point the administrator can create EC2 and compute instances in AWS and OCI portals. 
When creating the EC2 instance in AWS be sure to select the IaC VPC and NSG.

For destroying the deployment first modify the AWS VPN to use the "IaC_CGW" instead of the "New_IaC_CGW".

Use the following command to destroy the deployment:

- terraform destroy

