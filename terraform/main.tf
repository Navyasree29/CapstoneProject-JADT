provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("${path.module}/capstone-deploy-key.pub")
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "web" {
  ami           = "ami-01760eea5c574eb86"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "CapstoneWeb"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
