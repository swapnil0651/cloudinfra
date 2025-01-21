provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow_http"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
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
    Name = "Mysg"
  }
}

# Security group for ELB
resource "aws_security_group" "elb_sg" {
  name_prefix = "elb_sg"

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

  tags = {
    Name = "ELB-SG"
  }
}

# First EC2 instance
resource "aws_instance" "nextjs_instance1" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_http.name]
  key_name        = "mykey"
  user_data       = <<-EOF
  #!/bin/bash
  curl -s https://gist.githubusercontent.com/swapnil0651/8482bf8ce78d243869144e76927e0e3a/raw/5f4a41341b461f53b94bce346868449e3cf05d2a/ubuntusetup.sh | bash
EOF
  tags = {
    Name = "NextjsApp1"
  }
}

# Second EC2 instance
resource "aws_instance" "nextjs_instance2" {
  ami             = "ami-00bb6a80f01f03502"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_http.name]
  key_name        = "mykey"
  user_data       = <<-EOF
  #!/bin/bash
  curl -s https://gist.githubusercontent.com/swapnil0651/8482bf8ce78d243869144e76927e0e3a/raw/5f4a41341b461f53b94bce346868449e3cf05d2a/ubuntusetup.sh | bash
EOF
  tags = {
    Name = "NextjsApp2"
  }
}

# Classic Load Balancer
resource "aws_elb" "nextjs_elb" {
  name               = "nextjs-elb"
  availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  security_groups    = [aws_security_group.elb_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port          = 80
    lb_protocol      = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout            = 5
    target             = "HTTP:80/"
    interval           = 30
  }

  instances = [aws_instance.nextjs_instance1.id, aws_instance.nextjs_instance2.id]

  cross_zone_load_balancing = true
  idle_timeout             = 400

  tags = {
    Name = "NextjsELB"
  }
}

# Output both instance IPs and ELB DNS name
output "instance1_public_ip" {
  value = aws_instance.nextjs_instance1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.nextjs_instance2.public_ip
}

output "elb_dns_name" {
  value = aws_elb.nextjs_elb.dns_name
}