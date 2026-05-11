locals {

  #  Resolve VPC
  resolved_vpc_id = (
    var.vpc_id != "" ?
    data.aws_vpc.management[0].id :
    data.aws_vpc.management_by_tag[0].id
  )

  #  Subnet AZ mapping
  application_subnet_ids_by_az = zipmap(
    [for s in data.aws_subnets.application.ids :
      data.aws_subnet.by_id[s].availability_zone
    ],
    data.aws_subnets.application.ids
  )

  #  Naming
  common_resource_name = "${var.environment}-${var.service_subtype}"

  #  Common tags
  common_tags = {
    Environment    = var.environment
    Service        = var.service
    ServiceSubType = var.service_subtype
    Team           = var.team
  }

  #  AMI selection
  ami_id = var.ec2_ami_id != "" ? var.ec2_ami_id : data.aws_ami.al2023[0].id

  #  Instances
  instances = {
    master = {
      subnet_id = var.subnet_master
      name      = "${var.service}-${var.service_subtype}-01"
    }
    slave = {
      subnet_id = var.subnet_slave
      name      = "${var.service}-${var.service_subtype}-02"
    }
  }

  #  Vault → S3
  security_s3_data = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  shared_services_s3_data = data.vault_generic_secret.shared_services_s3.data
  resources_bucket_name   = local.shared_services_s3_data["resources_bucket_name"]

  #  Vault → KMS
  security_kms_keys_data  = data.vault_generic_secret.security_kms_keys.data
  ssm_kms_key_id          = local.security_kms_keys_data["session-manager-kms-key-arn"]

  kms_keys = data.vault_generic_secret.kms_keys.data
  cloudwatch_logs_kms_key = local.kms_keys["logs"]

  #  Account IDs
  account_ids_secrets = jsondecode(data.vault_generic_secret.account_ids.data_json)

  #  KMS alias
  kms_key       = data.vault_generic_secret.kms_key_alias.data
  kms_key_alias = local.kms_key["kms_key_alias"]

  #  SSH key
  ssh_public_key = base64decode(
    data.vault_generic_secret.ec2_user_ssh_public_key.data["ssh_public_key"]
  )

  #  SNS email
  sns_email_secret = data.vault_generic_secret.sns_email.data
  linux_sns_email  = local.sns_email_secret["sns_private_key"]

  #  AMI owner
  ami_owner    = data.vault_generic_secret.ami_owner.data
  ami_owner_id = local.ami_owner["ami_owner"]

  #  Disk config
  disk_info = {
    root_vol = {
      device = "xvda4"
      fstype = var.disk_fs_type
      path   = "/"
    }
  }
}
