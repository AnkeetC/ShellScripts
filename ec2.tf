

# generate AWS key pair for Jenkins
resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = "jenkins_key"
  public_key = tls_private_key.jenkins_key.public_key_openssh
}

resource "local_file" "jenkins_key_file" {
  content  = tls_private_key.jenkins_key.private_key_pem
  filename = "jenkins_key"
}

# create default VPC if one does not exist
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "default vpc"
  }
}

# use data source to get all availability zones in the region
#data "aws_availability_zones" "available_zones" {
  # ...
#}

# create default subnet if one does not exist
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1"
}

# create security group for the EC2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on ports 8080 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 8080
  ingress {
    description = "http proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow access on port 22
  ingress {
    description = "ssh access"
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

  tags = {
    Name = "jenkins server security group"
  }
}


# launch the EC2 instance and install website
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-079db87dc4c10ac91"
  instance_type               = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.jenkins_key_pair.key_name
  #user_data              = file("install_jenkins.sh")  # Assuming you have this script

  tags = {
    Name = "Jenkins EC2 Instance"
  }
}

# an empty resource block
resource "null_resource" "jenkins_setup" {
  # ssh into the EC2 instance
  connection {
    type        = "ssh"
    user        = "ec2-user"  # Change to your appropriate username
    private_key = tls_private_key.jenkins_key.private_key_pem
    host        = aws_instance.ec2_instance.public_dns
  }

  # copy the install_jenkins.sh file from your computer to the EC2 instance
  provisioner "file" {
    source      = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  # set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_jenkins.sh",
      "/tmp/install_jenkins.sh",
    ]
  }
}

# print the URL of the Jenkins server
output "website_url" {
  value = join("", ["http://", aws_instance.ec2_instance.public_dns, ":", "8080"])
}
