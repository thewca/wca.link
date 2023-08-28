provider "aws" {
}

provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"
}

# The API Gateway
resource "aws_api_gateway_rest_api" "wcalink_gateway" {
  name        = "WCAlink API Gateway"
  description = "The API Gateway for the wcalink shortener"
}
# Certificate for the https endpoint of the API Gateway
resource "aws_acm_certificate" "cert" {
  # API Gateway Certs need to live in us-east-1
  provider          = aws.us-east-1

  domain_name       = "wca.link"
  validation_method = "DNS"
}
# Route 53 Zone
resource "aws_route53_zone" "zone" {
  name         = "wca.link."
}

# Validate the Certificate with Route 53
resource "aws_route53_record" "cert_validation" {
  name    = "${tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name}"
  type    = "${tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type}"
  zone_id = "${aws_route53_zone.zone.id}"
  records = ["${tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value}"]
  ttl     = 60
  allow_overwrite = true # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/7918#issuecomment-503794355
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.us-east-1 # The cert exists in us-east-1 (see comments above for aws_acm_certificate)
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
# Custom Domain Name for the API Gateway Endpoint
resource "aws_api_gateway_domain_name" "wcalink_domain" {
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
  domain_name     = "wca.link"
}

# This is the Alias record for the API Gateway Domain Name
resource "aws_route53_record" "alias" {
  name    = aws_api_gateway_domain_name.wcalink_domain.domain_name
  type    = "A"
  zone_id = aws_route53_zone.zone.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.wcalink_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.wcalink_domain.cloudfront_zone_id
  }
}
# Map / to the custom domain
resource "aws_api_gateway_base_path_mapping" "prod" {
  api_id      = aws_api_gateway_rest_api.wcalink_gateway.id
  stage_name  = aws_api_gateway_deployment.wcalink_prod_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.wcalink_domain.domain_name
}

# Output URL for Testing
output "base_url" {
  value = aws_api_gateway_deployment.wcalink_prod_deployment.invoke_url
}

