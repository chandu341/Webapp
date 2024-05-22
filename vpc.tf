provider "aws" {
  region = "us-west-2"  # specify the region
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "The type of instance to create"
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI to use for the instance"
  default     = "ami-0c55b159cbfafe1f0"  # specify the AMI ID
}

# Create VPC
resource "aws_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

# Create Subnet
resource "aws_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  tags = {
    Name = "my-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-igw"
  }
}

# Create Route Table
resource "aws_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "my-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create Security Group
resource "aws_security_group" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-security-group"
  }
}

# Create EC2 Instance
resource "aws_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.name]

  tags = {
    Name = "my-ec2-instance"
  }
}
