resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow HTTP access to frontend on port 3000"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access to the frontend"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "frontend-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "shashank_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    delete_on_termination = true
  }

  tags = {
    Name = var.key_name
    Environment = var.environment
  }
  
}

# user data to install docker
resource "aws_instance" "ubuntu" {
    ami           = var.ami
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    vpc_security_group_ids = [aws_security_group.frontend_sg.id]
    user_data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y docker.io
        systemctl start docker
        systemctl enable docker
        usermod -aG docker ubuntu
        docker pull demoteam88/user-service:latest
        docker pull demoteam88/product-service:latest
        docker pull demoteam88/cart-service:latest
        docker pull demoteam88/e-commercestore-order-service:latest
        docker pull demoteam88/frontend:latest
        docker run -d -p 3001:3001 demoteam88/user-service:latest
        docker run -d -p 3002:3002 demoteam88/product-service:latest
        docker run -d -p 3003:3003 demoteam88/cart-service:latest
        docker run -d -p 3004:3004 demoteam88/e-commercestore-order-service:latest
        docker run -d -p 3000:3000 demoteam88/frontend:latest
    EOF
    
    tags = {
        Name = "ubuntu-docker-instance"
        Environment = var.environment
    }
}
