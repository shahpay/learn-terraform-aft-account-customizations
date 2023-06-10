# data "aws_caller_identity" "current" {}

# data "aws_region" "eu-west-2" {
#     provider = aws.euwest2
# }

# data "aws_region" "eu-west-1" {
#     provider = aws.euwest1
# }

# module securityhub {
#   providers = {
#     aws.useast2 = aws.useast2
#     aws.uswest2 = aws.uswest2
#     aws.cacentral1 = aws.cacentral1
#     aws.eucentral1 = aws.eucentral1
#     aws.euwest1 = aws.euwest1
#     aws.euwest2 = aws.euwest2
# }
#   source = "./modules/securityhub"
#   disabled_nis_control_all_region = disabled_nis_control_all_region
# }

# module securityhubeuwest2 {
#   providers = {
#     aws.euwest2 = aws.euwest2
#   }
#   source = "./modules/securityhub"
#   enabled_nis_control_all_region =  var.enabled_nis_control_all_region
# }

# module securityhubeuwest2 {
#   providers = {
#     aws.euwest2 = aws.euwest2
#   }
#   source = "./modules/securityhub"
#   enabled_control_all =  var.enabled_control_all
# }


# resource "aws_securityhub_standards_control" "preventthis" {
#   provider = aws.euwest1
#   standards_control_arn = "arn:aws:securityhub:${data.aws_region.eu-west-1.name}:${data.aws_caller_identity.current.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/2.3"
#   control_status        = "DISABLED"
#   disabled_reason       = "We handle password policies within Okta"
# }

# resource "aws_securityhub_standards_control" "preventthis1" {
#   provider = aws.euwest2
#   standards_control_arn = "arn:aws:securityhub:${data.aws_region.eu-west-2.name}:${data.aws_caller_identity.current.account_id}:control/cis-aws-foundations-benchmark/v/1.2.0/2.3"
#   control_status        = "DISABLED"
#   disabled_reason       = "We handle password policies within Okta"
# }

# resource "aws_securityhub_standards_control" "preventthis2" {
#   provider = aws.euwest1
#   standards_control_arn = "arn:aws:securityhub:${data.aws_region.eu-west-1.name}:${data.aws_caller_identity.current.account_id}:control/nist-800-53/v/5.0.0/APIGateway.4"
#   control_status        = "DISABLED"
#   disabled_reason       = "We handle password policies within Okta"
# }
