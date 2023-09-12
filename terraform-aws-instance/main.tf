terraform {
  cloud {
    organization = "stella1013-sandbox-org"

    workspaces {
      name = "sandbox-workspace"
    }
  }
  required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "5.16.1"
  }
}
}


provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
    type = string
}
variable "vpc_id" {
    type = string
}

variable "key_name" {
    type = string
}

variable "instance_name" {
    type = string
}
variable "cidr_block" {
    type = string
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "test_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_instance" "app-server-jenkins" {
  ami             = "ami-00a9282ce3b5ddfb1"
  instance_type   = "t2.micro"
  key_name = var.key_name
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  vpc_security_group_ids = [aws_security_group.jenkins_secgroup.id]
  user_data       = "${file("install_jenkins.sh")}"
  
  tags = {
    Name = var.instance_name
  }
}
resource "aws_security_group" "jenkins_secgroup" {
  name        = "jenkins_secgroup"
  description = "Allow Jenkins web traffic for inbound ssh and http and all outbound"
  vpc_id      = var.vpc_id
  

  ingress {
    description = "Allow from Personal CIDR block"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from Personal CIDR block"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_s3_bucket" "jenkins-secgroup-artifacts-s32" {
  bucket = "jenkins-secgroup-artifacts-s32"
}
resource "aws_s3_bucket_ownership_controls" "jenkins-secgroup-artifacts-s32" {
  bucket = aws_s3_bucket.jenkins-secgroup-artifacts-s32.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "jenkins-secgroup-artifacts-s32" {
  depends_on = [aws_s3_bucket_ownership_controls.jenkins-secgroup-artifacts-s32]

  bucket = aws_s3_bucket.jenkins-secgroup-artifacts-s32.id
  acl    = "private"
}

