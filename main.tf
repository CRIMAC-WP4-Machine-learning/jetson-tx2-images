variable "DH_USERNAME" {
  description = "Docker hub username"
  type        = string
  sensitive   = true
}

variable "DH_TOKEN" {
  description = "Docker hub token secret"
  type        = string
  sensitive   = true
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = "~> 0.14"

  backend "remote" {
    organization = "crimac"

    workspaces {
      name = "jetson-tx2-image-build"
    }
  }
}


provider "aws" {
  region = "eu-central-1"
}

resource "random_pet" "sg" {}

resource "aws_spot_instance_request" "build_docker" {
  ami                                  = "ami-08b6fc871ad49ff41"
  instance_type                        = "t4g.large"
  spot_price                           = "0.04"
  vpc_security_group_ids               = [aws_security_group.ssh-sg.id]
  key_name                             = "aws-two"
  instance_initiated_shutdown_behavior = "terminate"
  wait_for_fulfillment                 = true

  user_data = <<-EOF
              #!/bin/bash
              echo "${var.DH_USERNAME}" > /opt/user.docker
              echo "${var.DH_TOKEN}" > /opt/token.docker
              sudo apt-get update && sudo apt-get upgrade -y
              sudo apt-get install -y git docker.io
              cat /opt/token.docker | sudo docker login --username `cat /opt/user.docker` --password-stdin
              git clone https://github.com/CRIMAC-WP4-Machine-learning/jetson-tx2-images.git
              cd jetson-tx2-images
              ./build.sh > build.logs 2>&1
              sudo poweroff
              EOF

  root_block_device {
    volume_size           = "30"
    volume_type           = "gp3"
    delete_on_termination = true
  }
}

resource "aws_security_group" "ssh-sg" {
  name = "${random_pet.sg.id}-sg"

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

output "ssh-address" {
  value = "${aws_spot_instance_request.build_docker.public_dns}:22"
}