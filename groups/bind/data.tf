# VPC Lookup

data "aws_vpc" "heritage" {
  filter {
    name   = "tag:Name"
    values = ["vpc-heritage-${var.environment}"]
  }
}

# Subnet Discovery (IDs only)

data "aws_subnets" "application" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.heritage.id]
  }

  filter {
    name   = "tag:Name"
    values = [var.application_subnet_pattern]
  }
}

# Subnet Details (FULL objects)

data "aws_subnet" "application" {
  for_each = toset(data.aws_subnets.application.ids)

  id = each.value
}

# AMI Lookup (safe)
data "aws_ami" "amzn2023_base" {
  most_recent = true

  filter {
    name   = "owner-id"
    values = [local.ami_owner_id]
  }

  filter {
    name   = "name"
    values = ["amzn2023-base-*"]
  }

  name_regex = "^amzn2023-base-[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9]+)?$"
}

data "aws_ec2_managed_prefix_list" "administration_cidr_ranges" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "shared_services_cidr_ranges" {
  name = "shared-services-management-cidrs"
}

data "aws_kms_alias" "ebs" {
  name = local.kms_key_alias
}

data "aws_route53_zone" "bind" {
  name   = local.dns_zone
  vpc_id = data.aws_vpc.heritage.id
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "kms_key_alias" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.service}/kms_key_alias"
}

data "vault_generic_secret" "ami_owner" {
  path = "/applications/${var.aws_account}-${var.aws_region}/${var.service}/ami_owner"
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
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

data "vault_generic_secret" "sns" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.service}/chs-sns/"
}
