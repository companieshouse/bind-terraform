data "aws_ec2_managed_prefix_list" "administration_cidr_ranges" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "shared_services_cidr_ranges" {
  name = "shared-services-management-cidrs"
}

data "aws_kms_alias" "ebs" {
  name = local.kms_key_alias
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}
data "vault_generic_secret" "kms_key_alias" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.service}/kms_key_alias"
}

data "aws_vpc" "management" {
  count = var.vpc_id != "" ? 1 : 0

  id = var.vpc_id
}

data "aws_vpc" "management_by_tag" {
  count = var.vpc_id == "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.aws_vpc]
  }
}

data "aws_route53_zone" "chs_bind" {
  name         = "${var.dns_zone}."
  private_zone = true
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "vault_generic_secret" "ec2_user_ssh_public_key" {
  path = "/applications/${var.aws_account}-${var.aws_region}/${var.service}/ec2-user/${local.common_resource_name}"
}

data "aws_subnet" "master" {
  id = var.subnet_master
}

data "aws_subnet" "slave" {
  id = var.subnet_slave
}

data "aws_subnets" "application" {
  filter {
    name   = "vpc-id"
    values = [local.resolved_vpc_id]
  }

  filter {
    name   = "subnet-id"
    values = var.application_subnet_ids
  }
}

data "aws_subnet" "by_id" {
  for_each = toset(var.application_subnet_ids)

  id = each.value
}

data "aws_ami" "al2023" {
  count       = var.ec2_ami_id == "" ? 1 : 0
  most_recent = true
  owners      = ["591542846629"]

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
  path = "/applications/${var.aws_account}-${var.aws_region}/${var.service}/${var.service_subtype}"
  
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids/development"
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

data "vault_generic_secret" "sns_email" {
  path = "/applications/${var.aws_account}-${var.aws_region}/${var.service}"
}

data "vault_generic_secret" "sns_url" {
  path = "/applications/${var.aws_account}-${var.aws_region}/${var.service}"
}
