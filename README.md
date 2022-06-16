# Purpose:

Create VPC, Internet Gateway, Subnet, EIP, NAT gateway, Route Table.
                                                    

## Variable Inputs:

REQUIRED:
- namespace   (ex: project name);
- environment (ex: dev/prod);
- cidr_block  VPC CIDR block (ex:10.0.0.0/16);

OPTIONAL:

- dns_hostnames_enabled     Boolean flag to enable/disable DNS hostnames in the VPC"
                            Default     = true

- dns_support_enabled       A boolean flag to enable/disable DNS support in the VPC"
                            Default     = true
  
- nat_gateway_enabled       Set as "true" to create NAT gateway, and allocated EIP. Default = false;

## Resources created:

- VPC.                [1]
- Internet Gateway.   [1] (and attach to the public route table)
- Subnet.             [A set of public, private subnet per AZ]                         
- Route Table.        [2: public, private]                                     
- Elastic IP.         [1] (created if NAT gateway is enabled)
- NAT gateway.        [1] (created if NAT gateway is enabled)

## Resources naming convention:

- VPC, & IGW name:         namespace-environment
                            ex: sg-dev
- Subnet:                  namespace-environment-subnet type-AZ
                            ex: sg-dev-private-us-east-1b
- Route Table/NAT gateway: namespace-environment-public
                            ex: sg-dev-private, sg-dev-public
- EIP name:                namespace-environment-eip
                            ex: sg-dev-eip

# Steps to create the resources

1. Call the module from your tf code.
2. Specifying Variable Inputs along the module call.
3. Apply.

Example:

```
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source      = "git@github.com:studiographene/tf-modules.git//network"
  cidr_block  = "10.0.0.0/16"
  namespace   = "sg"
  environment = "dev"
}


```

3. From terminal: 

```
terraform init
```
```
terraform plan
```
```
terraform apply
```

!! You have successfully network components as per your specification !!

---


##OUTPUTS

```
- vpc_id:
    The ID of the VPC

- vpc_arn:
    The ARN of the VPC

- vpc_cidr_block:
    The primary IPv4 CIDR block of the VPC

- igw_id: 
    IGW ID

- public_subnet_ids:
    List of the created public subnets IDs

- private_subnet_ids:
    List of the created private subnets IDs

- ngw_id:
    NAT Gateway ID

- az_subnet_ids:
    Map of subnet IDs per AZ names

- az_subnet_arns:
    Map of subnet ARNs per AZ names

- az_subnet_cidr_blocks:
    Map of CIDR blocks per AZ names

- az_route_table_ids:
    Map of Route Table IDs per AZ names

- az_subnet_map:
    Map of AZ names to map of information about subnets
    
```