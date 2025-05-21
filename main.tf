# Create VPC
# Terraform aws create vpc
resource "aws_vpc" "dev_vpc" {
  cidr_block       = var.dev_vpc
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "dev vpc"
  }
}

# create internet gateway and attach it to VPC
# Terraform aws create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "internet gateway"
  }
}

# Create public subnet 
# Terraform aws create public subnet 
resource "aws_subnet" "Subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.subnet

  tags = {
    Name = "subnet"
  }
}



# Create  route table and add subnet to it
# Terraform aws create route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  
  tags = {
    Name = "route table"
  }
}

# Associate subnet to route table
# Terraform aws create route table
resource "aws_route_table_association" "public_subnet_1_route_table_association" {
  subnet_id      = aws_subnet.Subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Create security group
# Terraform aws create security group
resource "aws_security_group" "EC2-SG" {
  name        = "EC2-SG"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  tags = {
    Name = "EC2-SG"
  }
}

# Create security group rule for "ingress port 22"
# Terraform aws create security group rule
resource "aws_security_group_rule" "EC2-SG-ingress-port-22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my-ip]
  security_group_id = aws_security_group.EC2-SG.id
}


# Create security group rule for "ingress port 8080"
# Terraform aws create security group rule
resource "aws_security_group_rule" "EC2-SG-ingress-port-8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.EC2-SG.id
}

# Create security group rule for "egress"
# Terraform aws create security group rule
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  prefix_list_ids = []
  from_port         = 0
  security_group_id = aws_security_group.EC2-SG.id
}

resource "aws_key_pair" "destroyer" {
  key_name   = "ennyhardey key"
  public_key = "${file(var.public_key_location)}"
 
  }

  # Create aws instance
# Terraform aws create instance
resource "aws_instance" "Nginx-web-server" {
  ami           = "ami-0953476d60561c955"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Subnet.id
  security_groups = [ aws_security_group.EC2-SG.id ]
  availability_zone = var.availability_zone
  key_name = aws_key_pair.destroyer.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Nginx web server"
  }


}


  