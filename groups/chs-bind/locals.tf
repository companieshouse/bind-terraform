# Instance Definitions (recommended pattern)

locals {
  instances = {
    for name, cfg in var.instances :
    name => merge(cfg, {
      subnet_id = local.application_subnets_by_az[cfg.az]
    })
  }


  # VPC Resolution
  resolved_vpc_id = data.aws_vpc.heritage.id

  # Subnet Mapping (AZ → subnet_id)

  application_subnets_by_az = {
    for subnet_id, subnet in data.aws_subnet.application :
    subnet.availability_zone => subnet.id
  }


  # AMI Resolution (safe fallback optional)

  ami_id = var.ec2_ami_id != "" ? var.ec2_ami_id : data.aws_ami.al2023.id

  dns_zone = "${var.environment}.${var.dns_zone_suffix}"


  #  Naming
  common_resource_name = "${var.environment}-${var.service_subtype}"

  #  Common tags
  common_tags = {
    Environment    = var.environment
    Service        = var.service
    ServiceSubType = var.service_subtype
    Team           = var.team
  }

  #  Vault → S3

  security_s3_data = data.vault_generic_secret.security_s3_buckets.data

  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  shared_services_s3_data = data.vault_generic_secret.shared_services_s3.data

  resources_bucket_name = local.shared_services_s3_data["resources_bucket_name"]

  #  Vault → KMS

  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data

  ssm_kms_key_id = local.security_kms_keys_data["session-manager-kms-key-arn"]

  kms_keys = data.vault_generic_secret.kms_keys.data

  cloudwatch_logs_kms_key = local.kms_keys["logs"]

  #  Account IDs

  account_ids_secrets = jsondecode(data.vault_generic_secret.account_ids.data_json)

  bind_ami_owner_id = local.account_ids_secrets["heritage-development"]

  #  KMS alias


  kms_key_alias = data.vault_generic_secret.kms_key_alias.data["kms_key_alias"]

  #  SNS email
  sns_email = data.vault_generic_secret.sns.data["linux_email"]
  sns_url   = data.vault_generic_secret.sns.data["linux_url"]

  ssh_public_key = base64decode(data.vault_generic_secret.ec2_user_ssh_public_key.data["ssh_public_key"])

  #  Disk config

  disk_info = {
    root_vol = {
      device = "xvda4"
      fstype = var.disk_fs_type
      path   = "/"
    }
  }
}
