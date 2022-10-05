resource "aws_key_pair" "aws-key" {
  key_name   = format("%s-key", var.aws_ec2_instance_name)
  public_key = file(var.ssh_public_key_file)
}

resource "aws_security_group" "public" {
  name   = format("%s-public-sg", var.aws_ec2_instance_name, )
  vpc_id = var.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.custom_tags
}

resource "aws_security_group" "private" {
  name   = format("%s-private-sg", var.aws_ec2_instance_name)
  vpc_id = var.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16"]
  }

  tags = var.custom_tags
}

resource "aws_network_interface" "public" {
  subnet_id       = var.aws_subnet_public_id
  private_ips     = var.aws_ec2_public_interface_ips
  security_groups = [aws_security_group.public.id]
  tags            = var.custom_tags
}

resource "aws_network_interface" "private" {
  subnet_id       = var.aws_subnet_private_id
  private_ips     = var.aws_ec2_private_interface_ips
  security_groups = [aws_security_group.private.id]
  tags            = var.custom_tags
}

resource "aws_eip" "eip" {
  vpc               = true
  network_interface = aws_network_interface.public.id
  tags              = var.custom_tags
}

resource "aws_instance" "instance" {
  ami                         = lookup(var.amis, var.aws_region)
  instance_type               = var.aws_ec2_instance_type
  key_name                    = aws_key_pair.aws-key.id
  user_data                   = local.cloud_init_content
  user_data_replace_on_change = true

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.public.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.private.id
  }

  tags = var.custom_tags
}

resource "local_file" "instance_script" {
  depends_on = [aws_instance.instance]
  content    = local.script_content
  filename   = "${var.template_output_dir_path}/${var.aws_ec2_instance_script_file}"
}

resource "null_resource" "ec2_instance_provision_custom_data" {
  depends_on = [aws_instance.instance, local_file.instance_script]
  for_each = {for item in var.aws_ec2_instance_custom_data_dirs : item.name => item}

  connection {
    type        = var.provisioner_connection_type
    host        = aws_eip.eip.public_ip
    user        = var.provisioner_connection_user
    private_key = file(var.ssh_private_key_file)
  }

  provisioner "file" {
    source      = each.value.source
    destination = each.value.destination
  }
}

resource "null_resource" "ec2_execute_script_file" {
  depends_on = [null_resource.ec2_instance_provision_custom_data]
  connection {
    type        = var.provisioner_connection_type
    host        = aws_eip.eip.public_ip
    user        = var.provisioner_connection_user
    private_key = file(var.ssh_private_key_file)
  }

  provisioner "remote-exec" {
    inline = var.aws_ec2_instance_script.actions
  }
}