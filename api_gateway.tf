# The API Gateway
resource "aws_api_gateway_rest_api" "wcalink_gateway" {
  name        = "WCAlink API Gateway"
  description = "The API Gateway for the wcalink shortener"
}
# Certificate for the https endpoint of the API Gateway
resource "aws_acm_certificate" "cert" {
  domain_name       = "replaceme.ickler.cloud"
  validation_method = "DNS"
}
# Route 53 Zone
data "aws_route53_zone" "zone" {
  name         = "ickler.cloud."
  private_zone = false
}

# Validate the Certificate with Route 53
resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
# Custom Domain Name for the API Gateway Endpoint
resource "aws_api_gateway_domain_name" "wcalink_domain" {
  certificate_arn = "${aws_acm_certificate_validation.cert.certificate_arn}"
  domain_name     = "replaceme.ickler.cloud"
}

# This is the Alias record for the API Gateway Domain Name
resource "aws_route53_record" "alias" {
  name    = "${aws_api_gateway_domain_name.wcalink_domain.domain_name}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.zone.id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.wcalink_domain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.wcalink_domain.cloudfront_zone_id}"
  }
}
# Map / to the custom domain
resource "aws_api_gateway_base_path_mapping" "prod" {
  api_id      = "${aws_api_gateway_rest_api.wcalink_gateway.id}"
  stage_name  = "${aws_api_gateway_deployment.wcalink_prod_deployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.wcalink_domain.domain_name}"
}

# Output URL for Testing
output "base_url" {
  value = "${aws_api_gateway_deployment.wcalink_prod_deployment.invoke_url}"
}

