

data "aws_vpc" "default" {
  default = true
}

data "http" "my_ipv4" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  databases = {
    for key, data in var.databases : (key) => data if data.enabled == true
  }
  my_ip = "${chomp(data.http.my_ipv4.response_body)}/32"
}

resource "aws_security_group" "rds" {
  name   = "${var.env}_sg_rds_public"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${local.my_ip}"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${local.my_ip}"]
  }

  # allow outgoing traffic to all protocols
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Env  = var.env,
    Name = "${var.env}_sg_rds_public"
  })
}

resource "aws_db_instance" "databases" {
  for_each            = local.databases
  allocated_storage   = each.value.allocated_storage
  db_name             = each.value.name
  identifier          = "${var.env}-${each.value.engine}-${each.value.name}"
  engine              = each.value.engine
  engine_version      = each.value.engine_version
  instance_class      = var.instance_class
  username            = "test"
  password            = "%123456$"
  skip_final_snapshot = true

  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = merge(var.tags, {
    Name   = each.value.name,
    Engine = each.value.engine,
    Env    = var.env,
  })
}