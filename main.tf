#variable "vpc_id" {}

provider "aws" {
    region = "ap-northeast-1"
    access_key = "AKIAVNBIWGZRWOJBPTPJ"
    secret_key = "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"
}

# Create a VPC
resource "aws_vpc" "development-vpc" {
# 内网IP范围
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    #id - The ID of the VPC
    #instance_tenancy - Tenancy of instances spin up within VPC.
    #enable_dns_support - Whether or not the VPC has DNS support
    #enable_dns_hostnames - Whether or not the VPC has DNS hostname support
    #enable_classiclink - Whether or not the VPC has Classiclink enabled
    #default_network_acl_id - The ID of the network ACL created by default on VPC creation
    #default_security_group_id - The ID of the security group created by default on VPC creation
    #default_route_table_id - The ID of the route table created by default on VPC creation

    tags = {
        Name = "development-vpc",
        vpc_env: "dev"
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.subnet_cidr_blocks[0]
    availability_zone = var.availability_zones[1].name
    tags = {
        Name = "subnet-1-dev"
    }
}



data "aws_vpc" "selected" {
    #id = var.vpc_id
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.selected.id
    availability_zone = var.availability_zones[0].name
    #cidr_block   = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
    cidr_block = var.subnet_cidr_blocks[1]
    tags = {
        Name = "subnet-2-dev"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.development-vpc
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1
}

variable "dev-subnet-id" {
    description = "子网id"
    default = "subnet_efault_id"
}

variable "dev-vpc-id" {
    description = "vpc id"
    default = "vpc_efault_id"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_blocks" {
    type = list(string)
}
variable "environment" {
    type = string
}


variable "availability_zones" {
    type = list(object({
        name = string
        public_ip = string
    }))
}
