# Define input variables
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type    = string
  default = "my-new-key"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type    = string
  default = "subnet-0b2c395116ac4f14b"
}

variable "vpc_id" {
  type    = string
  default = "vpc-07a0f842e9a770840"
}


# Create EC2 instance
resource "aws_instance" "example" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ExampleInstance"
  }
}

# Create security group allowing SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

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
}

# Output instance ID and public IP address
output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
