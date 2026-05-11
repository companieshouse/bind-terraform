#  BLANK LINE (important)
resource "aws_instance" "bind" {
  for_each = local.instances

  ami           = local.ami_id
  instance_type = var.instance_type

  
subnet_id = (
  each.key == "master"
  ? data.aws_subnet.master.id
  : data.aws_subnet.slave.id
)

  vpc_security_group_ids = [
    var.security_group_id
  ]

  root_block_device {
    volume_size = var.root_volume_size
    encrypted   = var.encrypt_root_block_device
    iops        = var.root_block_device_iops
    kms_key_id  = data.aws_kms_alias.ebs.target_key_arn
    throughput  = var.root_block_device_throughput
    volume_type = var.root_block_device_volume_type

    tags = merge(local.common_tags, {
      Name   = "${each.value.name}-root"
      Backup = true
    })
  }

  tags = merge(local.common_tags, {
    Name = each.value.name
  })
}

#  Separate blocks again
output "selected_ami" {
  value = local.ami_id
}

resource "aws_key_pair" "bind_terraform" {
  key_name   = "${local.common_resource_name}-public-key"
  public_key = local.ssh_public_key
}
