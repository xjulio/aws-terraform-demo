# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "sg" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Lookup latest AMZ Linux from SSM parameter
data "aws_ssm_parameter" "amzn-linux-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
resource "aws_instance" "instance" {
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.iam_for_ec2_instance_profile.name

  # ssm paramter store latest ami value
  ami = data.aws_ssm_parameter.amzn-linux-ami.value

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.sg.id]

  # subnet
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    "Name" = "demo-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
            EOF
}
