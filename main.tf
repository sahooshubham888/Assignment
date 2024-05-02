# Define AWS provider and VPC resources
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "custom_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "custom_sg" {
  name        = "custom_sg"
  description = "Allow inbound traffic for MySQL, Tomcat, Memcached, Redis"
  vpc_id      = aws_vpc.custom_vpc.id

  // Define ingress rules for MySQL, Tomcat, Memcached, Redis
}

# Define AWS instance
resource "aws_instance" "custom_instance" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.custom_subnet.id
  key_name      = "my-key.pem"
  #security_groups = [aws_security_group.custom_sg.name]
}
