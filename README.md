# Terraform on AWS

This repository contains the Terraform code for setting up AWS architechture.

We set up the following architechture:
- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route
- Route Table Association
- Security Group
- AWS Key Pair
- EC2 Instance

## Requirements
- Terraform
- AWS
- VSCode

## System Design
![System Design.png](System%20Design.png)

## Installation, Setup, and Usage
1. Clone this repository
2. Navigate to ~/TerraformAWS
3. Ensure your VSCode is connected to your AWS credential profile in region us-east-1a (You can also change the region in variables.tf)
4. Install Terraform to VSCode
5. In providers.tf, make sure the shared config and credentials files are located in the right directory
6. Under datasource.tf, you may have to update the server type if the listed server type is deprecated.
   To do this, go to EC2 instance, select the free tier version of the ubuntu server and in AMI images, look up the server by id to get the owner id.
   Update owners to that id and update the AMI server id in values as well
7. In variables.tf change the host default value to "windows" if you are using windows, if not keep it as "linux"
8. To deploy the architechture run `terraform apply -auto-approve` in the terminal which will deploy the architecture without a check
9. You will now be able to ssh into the EC2 Instance via the VSCode command palette using Remote-SSH: Connect to Host and choosing the output ip listen in the terminal
10. To destroy the architechture run `terraform destroy -auto-approve` in the terminal which will deploy the architecture without a check
11. Please see Terraform's list of commands here: https://developer.hashicorp.com/terraform/cli/commands
