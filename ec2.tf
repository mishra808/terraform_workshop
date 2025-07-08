data "aws_ami" "os_image" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/*amd64*"]
  }
}



## key pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("tf-key.pub")
}


## VPC 

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

## Security Group

resource "aws_security_group" "security_group" {
  name        = "ec2-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "port 22 allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 80 allow"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "port 80 allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 443 allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

## ec2 instance 

resource "aws_instance" "web" {
  ami           = data.aws_ami.os_image.id
  instance_type = var.my_enviroment == "prod" ? "t2.medium" : "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.security_group.name]
  user_data = file("script.sh")

  tags = {
    Name = "test ec2"
  }

  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = "gp3"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("terra-key")
    host        = self.public_ip
  }

}

