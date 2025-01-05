# create security group for the public instance
resource "aws_security_group" "public-instance-sg" {
  name               = "${var.project_name}-public-instance-sg"
  description        = "enable http/https access on port 80/443, and ssh access on 22"
  vpc_id             = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags               = {
    Name             = "${var.project_name}-public-instance-sg"
  }
}

# create security group for the private instance
resource "aws_security_group" "private-instance-sg" {
  name               = "${var.project_name}-private-instance-sg"
  description        = "allow ssh and icmp access from the public instance security group"
  vpc_id             = var.vpc_id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.public-instance-sg.id]
  }

  ingress {
    description      = "icmp access"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    security_groups  = [aws_security_group.public-instance-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags               = {
    Name             = "${var.project_name}-private-instance-sg"
  }
}
