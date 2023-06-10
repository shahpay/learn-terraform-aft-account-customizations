terraform {
  required_version = ">= 0.13.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
      configuration_aliases = [aws.useast2, aws.uswest2, aws.cacentral1, aws.eucentral1, aws.euwest1, aws.euwest2 ]
    }
  }
}

locals  {
 nis_version = "5.0.0"
 disabled_reason = "Not needed for this usecase"
}

data "aws_region" "us-east-1" {}

data "aws_region" "us-east-2" {
  provider = aws.useast2
}

data "aws_region" "us-west-2" {
  provider = aws.uswest2
}

data "aws_region" "ca-central-1" {
  provider = aws.cacentral1
}

data "aws_region" "eu-central-1" {
  provider = aws.eucentral1
}

data "aws_region" "eu-west-1" {
  provider = aws.euwest1
}

data "aws_region" "eu-west-2" {
  provider = aws.euwest2
}


data "aws_caller_identity" "current_account" {}

resource "aws_securityhub_standards_control" "evaluate_controls_useast1" {
   for_each = var.disabled_nis_control_all_region
   control_status = "DISABLED"
   disabled_reason = local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.us-east-1.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}


resource "aws_securityhub_standards_control" "evaluate_controls_useast2" {
   provider = aws.useast2
   for_each = var.disabled_nis_control_all_region
   control_status = "DISABLED"
   disabled_reason  = local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.us-east-2.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}

resource "aws_securityhub_standards_control" "evaluate_controls_uswest2" {
   provider = aws.uswest2
   for_each = var.disabled_nis_control_all_region
   control_status = "DISABLED"
   disabled_reason  = local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.us-west-2.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}

resource "aws_securityhub_standards_control" "evaluate_controls_cacentral1" {
   provider = aws.cacentral1
   for_each = var.disabled_nis_control_all_region
   control_status = "DISABLED"
   disabled_reason  = local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.ca-central-1.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}

resource "aws_securityhub_standards_control" "evaluate_controls_eucentral1" {
   provider = aws.eucentral1
   for_each = var.disabled_nis_control_all_region
   control_status = "DISABLED"
   disabled_reason  = local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.eu-central-1.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}

resource "aws_securityhub_standards_control" "evaluate_controls_euwest1" {
   provider = aws.euwest1
   for_each = var.disabled_nis_control_all_region
   control_status = "DISABLED"
   disabled_reason  = local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.eu-west-1.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}

resource "aws_securityhub_standards_control" "evaluate_controls_euwest2" {
   provider = aws.euwest2
   for_each = var.disabled_nis_control_all_region
   control_status =  "DISABLED"
   disabled_reason  = local.disabled_reason
   standards_control_arn = "arn:aws:securityhub:${data.aws_region.eu-west-2.name}:${data.aws_caller_identity.current_account.account_id}:control/nist-800-53/v/${local.nis_version}/${each.value}"
}
