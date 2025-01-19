provider "aws" {
  region = "us-east-1" # Choose your preferred region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Mysn"
  }
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow_http"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
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
  ami           = "ami-0df8c184d5f6ae949" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  security_groups = [aws_security_group.allow_http.id]
  


  user_data = <<-EOF
              #!/bin/bash
              # Install Nginx and Docker
              yum update -y
              amazon-linux-extras enable docker
              yum install -y docker nginx
              service docker start
              service nginx start
              # Set up Nginx reverse proxy
              cat > /etc/nginx/conf.d/default.conf <<EOL
              server {
                  listen 80;
                  location / {
                      proxy_pass http://localhost:3000;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                  }
              }
              EOL
              systemctl enable nginx
              EOF

  tags = {
    Name = "NextjsApp"
  }
}


