resource "aws_route53_record" "chs_bind" {
  for_each = aws_instance.bind

  zone_id = data.aws_route53_zone.chs_bind.zone_id
  
  name = "${each.key}.${var.dns_zone}"
  type    = "A"
  ttl     = 300

  records = [each.value.private_ip]
}
