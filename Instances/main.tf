variable "key_path" {
  description = "Path to the private key file for SSH access"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

resource "aws_instance" "proxy" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = values(var.public_subnet_ids)[count.index]
  vpc_security_group_ids = [var.proxy_sg_id]
  key_name      = var.key_name

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"  # <-- Change to ec2-user for Amazon Linux
      private_key = file(var.key_path)
    }
    inline = [
      "sudo yum install -y epel-release",
      "sudo yum install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"    # <-- Change to ec2-user for Amazon Linux
    private_key = file(var.key_path)
    host        = self.public_ip
    timeout     = "5m"
    bastion_host = aws_instance.proxy[0].public_ip
  }

  tags = {
    Name = "bashar-proxy-${count.index + 1}"
  }
}

resource "aws_instance" "backend" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_ids[count.index == 0 ? "us-east-1a" : "us-east-1b"]
  vpc_security_group_ids = [var.backend_sg_id]
  key_name      = var.key_name

  provisioner "file" {
    source      = "${path.root}/app_files/"
    destination = "/home/ec2-user/app"
    connection {
      type            = "ssh"
      host            = self.private_ip
      user            = "ec2-user"
      private_key     = file(var.key_path)
      bastion_host    = aws_instance.proxy[0].public_ip
      bastion_user    = "ec2-user"
      bastion_private_key = file(var.key_path)
    }
  }

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      host                = self.private_ip
      user                = "ec2-user"
      private_key         = file(var.key_path)
      bastion_host        = aws_instance.proxy[0].public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.key_path)
    }
    inline = [
      "echo 'Provisioner successfully connected!'",
      "sudo yum update -y"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_path)
    host        = self.public_ip
    timeout     = "5m"
    bastion_host = aws_instance.proxy[0].public_ip
  }

  tags = {
    Name = "bashar-backend-${count.index + 1}"
  }
}