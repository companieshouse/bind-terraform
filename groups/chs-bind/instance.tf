resource "aws_instance" "bind" {
  for_each = local.instances

  ami           = local.ami_id
  instance_type = each.value.type
  subnet_id     = each.value.subnet_id

  key_name = aws_key_pair.bind.key_name

  iam_instance_profile = module.instance_profile.aws_iam_instance_profile.name
  vpc_security_group_ids = [
    aws_security_group.bind.id
  ]

  tags = merge(local.common_tags, {
    Name       = each.value.name
    Backup     = true
    Zone       = var.dns_zone_suffix
    Repository = var.origin
  })

  root_block_device {
    volume_size = var.root_volume_size
    encrypted   = var.encrypt_root_block_device
    iops        = var.root_block_device_iops
    kms_key_id  = data.aws_kms_alias.ebs.target_key_arn
    throughput  = var.root_block_device_throughput
    volume_type = var.root_block_device_volume_type
  }
}

resource "aws_key_pair" "bind" {
  key_name   = "${local.common_resource_name}"
  public_key = local.ssh_public_key
}
