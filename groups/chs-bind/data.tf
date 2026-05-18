data "aws_ec2_managed_prefix_list" "administration_cidr_ranges" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "shared_services_cidr_ranges" {
  name = "shared-services-management-cidrs"
}

data "aws_kms_alias" "ebs" {
  name = local.kms_key_alias
}

data "aws_route53_zone" "chs_bind" {
  name   = local.dns_zone
  vpc_id = data.aws_vpc.heritage.id
}


data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}
data "vault_generic_secret" "kms_key_alias" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.service}/kms_key_alias"
}

data "aws_vpc" "heritage" {
  id = var.vpc_id
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

# Discover application subnet IDs
data "aws_subnets" "application" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = [var.application_subnet_pattern]
  }
}

# Resolve each subnet into a full object (REQUIRED)
data "aws_subnet" "application" {
  for_each = toset(data.aws_subnets.application.ids)
  id       = each.value
}

data "aws_ami" "bind_ami" {
  count       = var.ec2_ami_id == "" ? 1 : 0
  most_recent = true
  owners      = [var.ami_owner_id]
#  owners      = ["591542846629"]

  filter {
    name   = "name"
    values = [var.ec2_ami_name_regex]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "vault_generic_secret" "ami_owner" {
  path = "/applications/${var.aws_account}-${var.aws_region}/${var.service}/ami_owner"
  
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids/"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "shared_services_s3" {
  path = "aws-accounts/shared-services/s3"
}

data "vault_generic_secret" "ec2_user_ssh_public_key" {
  path = "/applications/${var.aws_account}-${var.aws_region}/${var.service}/ec2-user/"
}

data "vault_generic_secret" "sns_email" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.service}/chs-sns/"
}

data "vault_generic_secret" "sns_url" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.service}/chs-sns/"
}
