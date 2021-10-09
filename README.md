# ali_vpc_ecs_slb_eip
Use Terraform to create a stack including VPC, ECS, SLB and EIP instances on the Alibaba Cloud;
NOTE: Please update the terraform.tfvars.BLANK and save it as terraform.tfvars;
To update the number of ECS, please update the variable "my_count" {default = "3"} in the variables.tf;

Create the stack
1) Install terraform
2) terraform init
3) terraform plan -out=plan001.out
4) terraform apply plan001.out

Destroy the stack
1) terraform destroy
