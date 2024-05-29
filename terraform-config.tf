terraform {
required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "DSS"
}

# Creating VPC
resource "aws_vpc" "tf_test_vpc_01" {
  cidr_block = "20.0.0.0/16"          
  instance_tenancy = "default"
  tags = {
    Name = "tf_test_vpc_01"
  }
}

# Creating public subnet
resource "aws_subnet" "tf_test_public_subnet_01" {
  # vpc_id     = aws_vpc.tf_test_vpc_01.id
  vpc_id     = "dadadaaa11223"
  cidr_block = "20.0.1.0/24" 
  
  tags = {
    Name = "tf_test_public_subnet_01"
  }
}

data "aws_vpc" "subnet_vpc_id" {
  id = aws_vpc.tf_test_vpc_01.id
}

check "validate_subnet" {
  assert {
    condition = aws_subnet.tf_test_public_subnet_01.vpc_id != ""
    error_message = "Associate at least one vpc id for module tf_test_public_subnet_01"
  }

  assert {
    condition = data.aws_vpc.subnet_vpc_id == aws_subnet.tf_test_public_subnet_01.vpc_id
    error_message = "Referenced vpc id must match with present vpc module"
  }
}

# Creating transit gateway
# resource "aws_ec2_transit_gateway" "tf_transit_gateway" {
#   tags = {
#     Name = "tf_transit_gateway"
#   }
#   default_route_table_association = "disable"
#   default_route_table_propagation = "disable"
# }

# Creating transit attachment for vpc
# resource "aws_ec2_transit_gateway_vpc_attachment" "tf_transit_gateway_attachment" {
#   subnet_ids         = toset([aws_subnet.tf_test_public_subnet_01.id])
#   transit_gateway_id = aws_ec2_transit_gateway.tf_transit_gateway.id
#   vpc_id             = aws_vpc.tf_test_vpc_01.id

#   tags = {
#     Name = "tf_transit_gateway_vpc_01_attachment"
#   }

#   depends_on = [ aws_ec2_transit_gateway.tf_transit_gateway ]
# }


# Creating route table for transit gateway
# resource "aws_ec2_transit_gateway_route_table" "tf_transit_gateway_route_table" {
#   transit_gateway_id = aws_ec2_transit_gateway.tf_transit_gateway.id
#   tags = {
#     Name = "tf_transit_gateway_route_table"
#   }
#   depends_on = [ aws_ec2_transit_gateway_vpc_attachment.tf_transit_gateway_attachment ]
# }


# Configuring route table for association
# resource "aws_ec2_transit_gateway_route_table_association" "tf_transit_gateway_route_table_association" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tf_transit_gateway_attachment.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tf_transit_gateway_route_table.id
#   depends_on = [ aws_ec2_transit_gateway_vpc_attachment.tf_transit_gateway_attachment, aws_ec2_transit_gateway_route_table.tf_transit_gateway_route_table]
# }

# Configuring route table for propogation
# resource "aws_ec2_transit_gateway_route_table_propagation" "tf_transit_gateway_route_table_propagation" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tf_transit_gateway_attachment.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tf_transit_gateway_route_table.id
#   depends_on = [ aws_ec2_transit_gateway_vpc_attachment.tf_transit_gateway_attachment, aws_ec2_transit_gateway_route_table.tf_transit_gateway_route_table]
# }

# Creating private subnet
# resource "aws_subnet" "tf_test_private_subnet_02" {
#   vpc_id     = aws_vpc.tf_test_vpc_01.id
#   cidr_block = "20.0.2.0/24"

#   tags = {
#     Name = "tf_test_private_subnet_01"
#   }
# }

# Creating Route table for public subnet
# resource "aws_route_table" "tf_rt_public_subnet" {
#   vpc_id = aws_vpc.tf_test_vpc_01.id
#   tags = {
#     Name = "tf_rt_public_subnet"
#   }
# }

# Creating Route table for private subnet
# resource "aws_route_table" "tf_rt_private_subnet" {
#   vpc_id = aws_vpc.tf_test_vpc_01.id
#   tags = {
#     Name = "tf_rt_private_subnet"
#   }
# }

# Attaching public subnet to public route table
# resource "aws_route_table_association" "tf_rt_associate_public_subnet" {
#   subnet_id      = aws_subnet.tf_test_public_subnet_01.id
#   route_table_id = aws_route_table.tf_rt_public_subnet.id
# }

# Attaching private subnet to private route table
# resource "aws_route_table_association" "tf_rt_associate_private_subnet" {
#   subnet_id      = aws_subnet.tf_test_private_subnet_02.id
#   route_table_id = aws_route_table.tf_rt_private_subnet.id
# }

# Route configuration for public subnet in route table
# resource "aws_route" "tf_rt_route_address_public_info" {
#   route_table_id            = aws_route_table.tf_rt_public_subnet.id
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.tf_internet_gateway_01.id
# }

# Creating gateway for allowing internet access to public subnet
# resource "aws_internet_gateway" "tf_internet_gateway_01" {
#   vpc_id = aws_vpc.tf_test_vpc_01.id

#   tags = {
#     Name = "tf_internet_gateway_01"
#   }
# }