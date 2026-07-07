# chs-bind - heritage dev/test server
Terraform for provisioning bind servers

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.37.0, < 6.0.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 3.25.0, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.37.0, < 6.0.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 3.25.0, < 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_instance_profile"></a> [instance\_profile](#module\_instance\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile | tags/1.0.283 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.bind_server_StatusCheckFailed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.bind_server_cpu95](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.bind_server_root_disk_space](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_instance.bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.chs_bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic.bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.bind_system_Subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.bind_system_Subscriptionhttps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_vpc_security_group_egress_rule.bind_all_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.bind_dns_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.bind_dns_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.bind_ssh_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.bind_ssh_shared_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_ami.al2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ec2_managed_prefix_list.administration_cidr_ranges](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.shared_services_cidr_ranges](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_kms_alias.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_route53_zone.chs_bind](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.heritage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.ami_owner](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.ec2_user_ssh_public_key](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_key_alias](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.shared_services_s3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.sns](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_version_pattern"></a> [ami\_version\_pattern](#input\_ami\_version\_pattern) | The pattern to use when filtering for AMI version by name. | `string` | `"*"` | no |
| <a name="input_application_subnet_pattern"></a> [application\_subnet\_pattern](#input\_application\_subnet\_pattern) | Tag value used to filter application subnets | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS account in which resources will be provisioned. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be created. | `string` | n/a | yes |
| <a name="input_default_log_retention_in_days"></a> [default\_log\_retention\_in\_days](#input\_default\_log\_retention\_in\_days) | The default log retention period in days to be used for CloudWatch log groups. | `number` | n/a | yes |
| <a name="input_disk_fs_type"></a> [disk\_fs\_type](#input\_disk\_fs\_type) | Default filesytem type for root/ebs block devices | `string` | `"xfs"` | no |
| <a name="input_dns_zone_suffix"></a> [dns\_zone\_suffix](#input\_dns\_zone\_suffix) | The common DNS hosted zone suffix used across accounts. | `string` | n/a | yes |
| <a name="input_ec2_ami_id"></a> [ec2\_ami\_id](#input\_ec2\_ami\_id) | Explicit AMI ID (overrides regex lookup if set) | `string` | `""` | no |
| <a name="input_encrypt_root_block_device"></a> [encrypt\_root\_block\_device](#input\_encrypt\_root\_block\_device) | Defines whether the EBS volume should be encrypted with the cluster's KMS key | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name to be used when provisioning AWS resources. | `string` | n/a | yes |
| <a name="input_hashicorp_vault_password"></a> [hashicorp\_vault\_password](#input\_hashicorp\_vault\_password) | The password used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_hashicorp_vault_username"></a> [hashicorp\_vault\_username](#input\_hashicorp\_vault\_username) | The username used when retrieving configuration from Hashicorp Vault | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number EC2 instances to create. | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for EC2 instances. | `string` | `"t3.medium"` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Map of EC2 instances to create | <pre>map(object({<br/>    name = string<br/>    type = string<br/>    az   = string<br/>  }))</pre> | <pre>{<br/>  "bind-a": {<br/>    "az": "eu-west-2a",<br/>    "name": "bind-a",<br/>    "type": "t3.micro"<br/>  },<br/>  "bind-b": {<br/>    "az": "eu-west-2b",<br/>    "name": "bind-b",<br/>    "type": "t3.micro"<br/>  }<br/>}</pre> | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Variable to determine is monitoring is enabled | `bool` | `false` | no |
| <a name="input_origin"></a> [origin](#input\_origin) | Github Repository where instance code resides | `string` | `"chs-bind-terraform"` | no |
| <a name="input_root_block_device_iops"></a> [root\_block\_device\_iops](#input\_root\_block\_device\_iops) | The required IOPS on the EBS volume; 3000 is the gp3 default | `number` | `3000` | no |
| <a name="input_root_block_device_throughput"></a> [root\_block\_device\_throughput](#input\_root\_block\_device\_throughput) | The required EBS volume throughput in MiB/s; 125 is the gp3 default | `number` | `125` | no |
| <a name="input_root_block_device_volume_type"></a> [root\_block\_device\_volume\_type](#input\_root\_block\_device\_volume\_type) | The type of EBS volume to provision | `string` | `"gp3"` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | The size of the root volume in gibibytes (GiB). | `number` | `25` | no |
| <a name="input_service"></a> [service](#input\_service) | The service name to be used when creating AWS resources. | `string` | n/a | yes |
| <a name="input_service_subtype"></a> [service\_subtype](#input\_service\_subtype) | The service subtype name to be used when creating AWS resources. | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | The team name for ownership of this service. | `string` | `"Linux/Storage"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name tag of the VPC to look up | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | AMI used for all instances |
| <a name="output_application_subnets_by_az"></a> [application\_subnets\_by\_az](#output\_application\_subnets\_by\_az) | Resolved subnet mapping by AZ |
| <a name="output_instance_azs"></a> [instance\_azs](#output\_instance\_azs) | Map of AZs keyed by instance name |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | Map of instance IDs keyed by instance name |
| <a name="output_instance_private_ips"></a> [instance\_private\_ips](#output\_instance\_private\_ips) | Map of private IPs keyed by instance name |
| <a name="output_instance_subnet_ids"></a> [instance\_subnet\_ids](#output\_instance\_subnet\_ids) | Map of subnet IDs used by each instance |
| <a name="output_sns_email"></a> [sns\_email](#output\_sns\_email) | SNS email/URL from Vault (if available) |
<!-- END_TF_DOCS -->