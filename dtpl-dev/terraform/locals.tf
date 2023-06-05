locals {
  sso_admin_role = "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_${var.sso_suffix}"
}