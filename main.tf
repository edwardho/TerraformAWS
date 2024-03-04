# DEV
# Create a Dev VPC
resource "aws_vpc" "eh_dev_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc"
  }
}

# Create a Dev Subnet
resource "aws_subnet" "eh_dev_public_subnet" {
  vpc_id                  = aws_vpc.eh_dev_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_az

  tags = {
    Name = "dev-public-subnet"
  }
}

# Create a Dev Internet Gateway
resource "aws_internet_gateway" "eh_dev_internet_gateway" {
  vpc_id = aws_vpc.eh_dev_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# Create a Dev Route Table
resource "aws_route_table" "eh_dev_public_rt" {
  vpc_id = aws_vpc.eh_dev_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

# Create a Dev Route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.eh_dev_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eh_dev_internet_gateway.id
}

# Create a Dev Route Table Association
resource "aws_route_table_association" "eh_dev_public_assoc" {
  subnet_id      = aws_subnet.eh_dev_public_subnet.id
  route_table_id = aws_route_table.eh_dev_public_rt.id
}

# Create a Dev Security Group
resource "aws_security_group" "eh_dev_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.eh_dev_vpc.id

  # Under Ingress CIDR Blocks add your IP if you don't want open Ingress
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidrs
    description = "HTTPS"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidrs
    description = "HTTP"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidrs
    description = "SSH"
  }

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = var.ingress_ips
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "eh_auth" {
  key_name   = "ehkey"
  public_key = file("~/.ssh/ehkey.pub")
}

# Dev Instance
resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.eh_auth.id
  vpc_security_group_ids = [aws_security_group.eh_dev_sg.id]
  subnet_id              = aws_subnet.eh_dev_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip
      user         = "ubuntu"
      identityfile = "~/.ssh/ehkey"
    })
    interpreter = var.host_os == "linux" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }
}

# PROD