
data "aws_vpc" "default" {
  default = true
}

data "http" "my_ipv4" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  my_ip   = "${chomp(data.http.my_ipv4.response_body)}/32"
  servers = merge([for item in var.servers : item]...)
}

resource "aws_security_group" "webservers" {
  name   = "webservers"
  vpc_id = data.aws_vpc.default.id

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
    cidr_blocks = ["${local.my_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}


resource "aws_key_pair" "ssh_auth" {
  key_name   = "user ssh key"
  public_key = file(var.ssh_key_path)
}

resource "aws_instance" "web" {
  for_each      = local.servers
  ami           = var.ami
  instance_type = var.instance_type
  depends_on = [
    aws_security_group.webservers,
    aws_key_pair.ssh_auth,
  ]
  
  key_name = aws_key_pair.ssh_auth.id
  vpc_security_group_ids = [
    aws_security_group.webservers.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd 
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Welcome to the terraform world</h1>" |sudo tee -a /var/www/html/index.html
    echo "<h2>By server: ${each.key}</h2>" |sudo tee -a /var/www/html/index.html
  EOF
  
  tags = merge(var.tags, {
    "Name" = each.key
  })
}

