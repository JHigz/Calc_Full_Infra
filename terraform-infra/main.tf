provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "cyber94-jhiguita-calc-bucket"
    key = "tfstate/calc_full/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "cyber94_calc_full_infra_jhiguita_dynamodb_table_lock"
    encrypt = true
  }
}

resource "aws_vpc" "cyber94_calc_full_infra_jhiguita_vpc_tf" {
  cidr_block = "10.107.0.0/16"

  tags = {
  Name = "cyber94_calc_full_infra_jhiguita_vpc"
  }
}


resource "aws_subnet" "cyber94_calc_full_infra_jhiguita_subnet_app_tf"{
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id
  cidr_block = "10.107.1.0/24"

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_subnet"
  }
}

resource "aws_subnet" "cyber94_calc_full_infra_jhiguita_subnet_db_tf"{
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id
  cidr_block = "10.107.2.0/24"

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_subnet"
  }
}

resource "aws_subnet" "cyber94_calc_full_infra_jhiguita_subnet_bastion_tf"{
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id
  cidr_block = "10.107.3.0/24"

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_subnet"
  }
}

resource "aws_internet_gateway" "cyber94_calc_full_infra_jhiguita_ig_tf"{
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_ig"
  }
}


resource "aws_route_table" "cyber94_calc_full_infra_jhiguita_route_tf" {
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.cyber94_calc_full_infra_jhiguita_ig_tf.id
    }


  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_route"
  }
}

resource "aws_route_table_association" "cyber94_calc_full_infra_jhiguita_rt_association_app_tf"{
  subnet_id= aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_app_tf.id
  route_table_id = aws_route_table.cyber94_calc_full_infra_jhiguita_route_tf.id
}

resource "aws_route_table_association" "cyber94_calc_full_infra_jhiguita_rt_association_bastion_tf"{
  subnet_id= aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_bastion_tf.id
  route_table_id = aws_route_table.cyber94_calc_full_infra_jhiguita_route_tf.id
}


resource "aws_network_acl" "cyber94_calc_full_infra_jhiguita_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id

  ingress {
    protocol   = "tcp"
    rule_no    = 50
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
    }
  ingress {
    protocol   = "tcp"
    rule_no    = 60
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 5000
    to_port    = 5000
    }
  ingress {
    protocol   = "tcp"
    rule_no    = 70
    action     = "allow"
    cidr_block = "86.14.143.0/24"
    from_port  = 22
    to_port    = 22
    }

  egress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
    }

  egress {
    protocol   = "tcp"
    rule_no    = 20
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
    }

  egress {
    protocol   = "tcp"
    rule_no    = 30
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
    }

  egress {
    protocol = "tcp"
    rule_no = 40
    action = "allow"
    cidr_block = "10.107.2.0/24"
    from_port = 3306
    to_port = 3306
  }


subnet_ids = [aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_app_tf.id]

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_nacl_app"
  }
}

resource "aws_network_acl" "cyber94_calc_full_infra_jhiguita_nacl_db_tf" {
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id

  ingress {
    protocol   = "tcp"
    rule_no    = 30
    action     = "allow"
    cidr_block = "10.107.1.0/24"
    from_port  = 3306
    to_port    = 3306
    }
  ingress {
    protocol   = "tcp"
    rule_no    = 40
    action     = "allow"
    cidr_block = "10.107.3.0/24"
    from_port  = 22
    to_port    = 22
    }

  egress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
    }

  egress {
    protocol   = "tcp"
    rule_no    = 20
    action     = "allow"
    cidr_block = "10.107.3.0/24"
    from_port  = 1024
    to_port    = 65535
    }



subnet_ids = [aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_db_tf.id]

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_nacl_db"
  }
}

resource "aws_network_acl" "cyber94_calc_full_infra_jhiguita_nacl_bastion_tf" {
  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id

  ingress {
    protocol   = "tcp"
    rule_no    = 30
    action     = "allow"
    cidr_block = "10.107.2.0/24"
    from_port  = 1024
    to_port    = 65535
    }

  ingress {
    protocol   = "tcp"
    rule_no    = 40
    action     = "allow"
    cidr_block = "86.14.143.0/24"
    from_port  = 22
    to_port    = 22
    }

  egress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = "10.107.2.0/24"
    from_port  = 22
    to_port    = 22
    }

  egress {
    protocol   = "tcp"
    rule_no    = 20
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
    }



subnet_ids = [aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_bastion_tf.id]

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_nacl_bastion"
  }
}

resource "aws_security_group" "cyber94_calc_full_infra_jhiguita_sg_app_tf"{
  name = "cyber94_calc_full_infra_jhiguita_sg_app"

  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["86.14.143.0/24"]
  }

  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.107.2.0/24"]
  }



  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_sg_app"
  }
}

resource "aws_security_group" "cyber94_calc_full_infra_jhiguita_sg_db_tf"{
  name = "cyber94_calc_full_infra_jhiguita_sg_db"

  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.107.3.0/24"]
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.107.1.0/24"]
  }

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_sg_db"
  }
}

resource "aws_security_group" "cyber94_calc_full_infra_jhiguita_sg_bastion_tf"{
  name = "cyber94_calc_full_infra_jhiguita_sg_bastion"

  vpc_id = aws_vpc.cyber94_calc_full_infra_jhiguita_vpc_tf.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["86.14.143.0/24"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.107.2.0/24"]
  }


  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_sg_bastion"
  }
}

resource "aws_instance" "cyber94_calc_full_infra_jhiguita_server_app_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jhiguita"
  associate_public_ip_address = true

  subnet_id = aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_app_tf.id
  vpc_security_group_ids = [aws_security_group.cyber94_calc_full_infra_jhiguita_sg_app_tf.id]

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_server_app"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/kali/.ssh/cyber94-jhiguita.pem")
    }

  provisioner "remote-exec" {
    inline = [
      "pwd"
    ]
  }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command = "ansible-playbook -i ${self.public_ip}, -u ubuntu playbook.yml"
    }
}

resource "aws_instance" "cyber94_calc_full_infra_jhiguita_server_db_tf" {
  ami = "ami-0d1c7c4de1f4cdc9a"
  instance_type = "t2.micro"
  key_name = "cyber94-jhiguita"
  associate_public_ip_address = false

  subnet_id = aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_db_tf.id
  vpc_security_group_ids = [aws_security_group.cyber94_calc_full_infra_jhiguita_sg_db_tf.id]

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_server_db"
  }
}

  resource "aws_instance" "cyber94_calc_full_infra_jhiguita_server_bastion_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-jhiguita"
  associate_public_ip_address = true
  subnet_id = aws_subnet.cyber94_calc_full_infra_jhiguita_subnet_bastion_tf.id
  vpc_security_group_ids = [aws_security_group.cyber94_calc_full_infra_jhiguita_sg_bastion_tf.id]

  tags = {
    Name = "cyber94_calc_full_infra_jhiguita_server_bastion"
  }

  lifecycle {
    create_before_destroy = true
  }

}
