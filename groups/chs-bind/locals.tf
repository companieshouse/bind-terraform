# Instance Definitions (recommended pattern)

locals {
  instances = {
    for name, cfg in var.instances :
    name => {
      name = cfg.name
      type = cfg.type
      az   = cfg.az

      subnet_id = try(
        local.application_subnets_by_az[cfg.az],
        null
      )
    }
  }
}

# VPC Resolution

locals {
  resolved_vpc_id = data.aws_vpc.heritage.id
}

# Subnet Mapping (AZ → subnet_id)

locals {
  application_subnets_by_az = {
    for subnet_id, subnet in data.aws_subnet.application :
    subnet.availability_zone => subnet.id
  }
}


# AMI Resolution (safe fallback optional)

locals {
  ami_id = var.ec2_ami_id != "" ? var.ec2_ami_id : try(data.aws_ami.al2023.id, null)
}

locals {
dns_zone             = "${var.environment}.${var.dns_zone_suffix}"
}

  #  Naming
locals {
  common_resource_name = "${var.environment}-${var.service_subtype}"
}

  #  Common tags
locals {
  common_tags = {
    Environment    = var.environment
    Service        = var.service
    ServiceSubType = var.service_subtype
    Team           = var.team
  }
}


  #  Vault → S3
locals {
  security_s3_data = data.vault_generic_secret.security_s3_buckets.data
}

locals {
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]
}

locals {
  shared_services_s3_data = data.vault_generic_secret.shared_services_s3.data
}

locals {
  resources_bucket_name   = local.shared_services_s3_data["resources_bucket_name"]
}

  #  Vault → KMS
locals {
  security_kms_keys_data  = data.vault_generic_secret.security_kms_keys.data
}

locals {  
  ssm_kms_key_id          = local.security_kms_keys_data["session-manager-kms-key-arn"]
}

locals {
  kms_keys = data.vault_generic_secret.kms_keys.data
}

locals { 
  cloudwatch_logs_kms_key = local.kms_keys["logs"]
}


  #  Account IDs
locals {
  account_ids_secrets = jsondecode(data.vault_generic_secret.account_ids.data_json)
}

locals { 
  bind_ami_owner_id = local.account_ids_secrets["heritage-development"]
}
  #  KMS alias
locals {
  kms_key       = data.vault_generic_secret.kms_key_alias.data
}

locals {
  kms_key_alias = local.kms_key["kms_key_alias"]
}
  #  SNS email
locals { 
 sns_email_secret = data.vault_generic_secret.sns_email.data
}

locals {
  linux_sns_email  = local.sns_email_secret["linux_email"]
}


  #  AMI owner
#locals {
#  ami_owner    = data.vault_generic_secret.ami_owner.data
#}

#locals {
#  ami_owner_id = local.ami_owner["ami_owner"]
#}

locals {
  ssh_public_key = base64decode(data.vault_generic_secret.ec2_user_ssh_public_key.data["ssh_public_key"])
}

  #  Disk config
locals {
  disk_info = {
    root_vol = {
      device = "xvda4"
      fstype = var.disk_fs_type
      path   = "/"
    }
  }
}
