# provider "aws" {
#   region = var.aws_region
#   default_tags {
#     tags = {
#       Environment = "Test"
#       Name        = "Provider Tag"
#     }
#   }
# }

terraform {
  required_version = ">= 0.13.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
      configuration_aliases = [ aws.euwest1, aws.euwest2 ]
    }
  }
}

locals  {
 nis_version = "5.0.0"
 disabled_reason = "Not needed for our usecase"
}

data "aws_region" "euwest1" { 
    provider = aws.euwest1
 }

data "aws_region" "euwest2" { 
    provider = aws.euwest2
 }


data "aws_caller_identity" "current_account" {}

resource "aws_securityhub_standards_control" "evaluate_controls_euwest1" {
   provider = aws.euwest1
   for_each = var.disabled_nis_control_all_region
   control_status = "${can(var.enabled_nis_control_all_region["${each.key}"])}" ? "ENABLED" : "DISABLED"
   disabled_reason  = "${can(var.enabled_nis_control_all_region["${each.key}"])}" ? null : local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.euwest1.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}

resource "aws_securityhub_standards_control" "evaluate_controls_euwest2" {
   provider = aws.euwest2
   for_each = var.disabled_nis_control_all_region
   control_status = "${can(var.enabled_nis_control_all_region["${each.key}"])}" ? "ENABLED" : "DISABLED"
   disabled_reason  = "${can(var.enabled_nis_control_all_region["${each.key}"])}" ? null : local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.euwest2.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}