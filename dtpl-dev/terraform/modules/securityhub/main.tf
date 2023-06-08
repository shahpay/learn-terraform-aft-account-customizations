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
      configuration_aliases = [ aws.region ]
    }
  }
}

locals  {
 nis_version = "5.0.0"
}

data "aws_region" "current_region" {  }

data "aws_caller_identity" "current_account" {}

resource "aws_securityhub_standards_control" "disabled_control_all" {
   for_each = {for index in var.disabled_control_all:  index.control_id => index}
   control_status = "${contains(var.enabled_control_all, "${each.value.control_id}")}" ? "ENABLED" : "DISABLED"
   disabled_reason  = "${contains(var.enabled_control_all, "${each.value.control_id}")}" ? "disabled reason" : null
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.current_region.name}:${data.aws_region.current_account.name}:control/standards/nist-800-53/v/${locals.nis_version}/${each.value.control_id}"
}