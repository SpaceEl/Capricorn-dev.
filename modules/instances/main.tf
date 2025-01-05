# create a data source for the latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu-20-04-LTS-free-tier" {
  most_recent            = true
  owners                 = ["099720109477"]
  filter {
    name                 = "name"
    values               = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name                 = "virtualization-type"
    values               = ["hvm"]
  }
  filter {
    name                 = "root-device-type"
    values               = ["ebs"]
  }
  filter {
    name                 = "architecture"
    values               = ["x86_64"]
  }
  filter {
    name                 = "block-device-mapping.volume-type"
    values               = ["gp2"]
  }
  filter {
    name                 = "block-device-mapping.volume-size"
    values               = ["8"]
  }
}

# creates a PEM (and OpenSSH) formatted private key
resource "tls_private_key" "rsa-4096-key" {
  algorithm              = "RSA"
  rsa_bits               = 4096
}

# creates a keypair in AWS
resource "aws_key_pair" "key_pair" {
  key_name               = "${var.project_name}-key"
  public_key             = tls_private_key.rsa-4096-key.public_key_openssh
}

# save the private key on the local filesystem
resource "local_file" "private_key" {
  content                = tls_private_key.rsa-4096-key.private_key_pem
  filename               = "${path.module}/${var.project_name}-key.pem"
}

# create multiple ec2 instances, one on the private subnet and one on the public subnet, using the private security group and public security group respectively
resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.ubuntu-20-04-LTS-free-tier.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = var.private_data_subnet_az2_id
  vpc_security_group_ids = [var.private-instance-sg-id]
  user_data              = file("${path.module}/installer.sh")

  tags                   = {
    Name                 = "${var.project_name}-private-instance"
  }
}

resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.ubuntu-20-04-LTS-free-tier.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = var.public_subnet_az1_id
  vpc_security_group_ids = [var.public-instance-sg-id]
  user_data              = file("${path.module}/installer.sh")

  tags                   = {
    Name                 = "${var.project_name}-public-instance"
    env                  = var.env
  }
}