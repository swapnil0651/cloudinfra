provider "aws" {
  region = "ap-south-1" # Choose your preferred region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Mysn"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow_http"
  vpc_id      = aws_vpc.main.id

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

resource "aws_instance" "nextjs_instance" {
  ami           = "ami-00bb6a80f01f03502" # Ubuntu
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.allow_http.id]
  key_name      = "mykey"

  user_data = <<-EOF
  #!/bin/bash
  curl -s https://gist.githubusercontent.com/swapnil0651/8482bf8ce78d243869144e76927e0e3a/raw/5f4a41341b461f53b94bce346868449e3cf05d2a/ubuntusetup.sh | bash
EOF


  tags = {
    Name = "NextjsApp"
  }
}

output "ec2_public_ip" {
  value = aws_instance.nextjs_instance.public_ip
}