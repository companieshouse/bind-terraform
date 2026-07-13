# Instance IDs

output "instance_ids" {
  description = "Map of instance IDs keyed by instance name"
  value = {
    for name, instance in aws_instance.bind-ns :
    name => instance.id
  }
}

# Private IPs

output "instance_private_ips" {
  description = "Map of private IPs keyed by instance name"
  value = {
    for name, instance in aws_instance.bind-ns :
    name => instance.private_ip
  }
}

# Availability Zones

output "instance_azs" {
  description = "Map of AZs keyed by instance name"
  value = {
    for name, instance in aws_instance.bind-ns :
    name => instance.availability_zone
  }
}

# Subnet IDs (resolved)

output "instance_subnet_ids" {
  description = "Map of subnet IDs used by each instance"
  value = {
    for name, instance in aws_instance.bind-ns :
    name => instance.subnet_id
  }
}

# AMI used

output "ami_id" {
  description = "AMI used for all instances"
  value       = data.aws_ami.amzn2023_base.id
}

# SNS Email (safe)

output "sns_email" {
  description = "SNS email/URL from Vault (if available)"
  value       = local.sns_email
  sensitive   = true
}

# Subnet Map (AZ → subnet_id)

output "application_subnets_by_az" {
  description = "Resolved subnet mapping by AZ"
  value       = local.application_subnets_by_az
}
