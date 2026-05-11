resource "aws_instance" "bind" {
  count = var.instance_count

  ami           = data.aws_ami.chs-bind_ami.id
  instance_type = var.instance_type
#subnet_id     = element(local.application_subnet_ids_by_az, count.index)
  subnet_id                   = var.subnet_master
  key_name      = aws_key_pair.bind_terraform.key_name

  iam_instance_profile   = module.instance_profile.aws_iam_instance_profile.name
  vpc_security_group_ids = [aws_security_group.bind.id]
  tags = merge(local.common_tags, {
#    Name       = "${local.common_resource_name}-${count.index + 1}"
    Name      = "${var.service_subtype}-1"
    Repository = var.origin
    Backup     = true
    Hostname   = "${var.service_subtype}-${count.index + 1}"
    Zone       = var.dns_zone
  })

  root_block_device {
    volume_size = var.root_volume_size
    encrypted   = var.encrypt_root_block_device
    iops        = var.root_block_device_iops
    kms_key_id  = data.aws_kms_alias.ebs.target_key_arn
    throughput  = var.root_block_device_throughput
    volume_type = var.root_block_device_volume_type
    tags = merge(local.common_tags, {
      Name   = "${local.common_resource_name}-${count.index + 1}-root"
      Backup = true
    })
  }
}
resource "aws_key_pair" "bind_terraform" {
  key_name   = "${local.common_resource_name}-public-key"
  public_key = local.ssh_public_key
}
