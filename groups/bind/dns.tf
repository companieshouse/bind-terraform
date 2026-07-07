resource "aws_route53_record" "bind" {
  for_each = aws_instance.bind

  zone_id = data.aws_route53_zone.bind.zone_id

  name = "${each.key}.${local.dns_zone}"
  type = "A"
  ttl  = 300

  records = [each.value.private_ip]
}
