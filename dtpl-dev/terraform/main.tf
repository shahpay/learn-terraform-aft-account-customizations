# ####################################
# A role that can be assumed by github actions to perform deployment within the sandbox accounts
# ####################################

resource "aws_iam_role" "githubactions-ci" {
  name = "githubactions-ci"
  assume_role_policy = templatefile("./iam_policies/allow_assume_githubactions_ci.json", {
    sso_admin_role = local.sso_admin_role,
    account_id     = var.account_id
  })

  tags = local.tags
}

# ####################################
# A policy that can would allow the github actions to perform the provisioning
# ####################################

resource "aws_iam_role_policy_attachment" "githubactions-ci-policy-attachment" {
  role       = aws_iam_role.githubactions-ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_ebs_encryption_by_default" "default_encryption" {
  enabled = true
}

resource "aws_ebs_encryption_by_default" "default_encryption_euw" {
  provider = aws.euwest1
  enabled  = true
}

resource "aws_ebs_encryption_by_default" "default_encryption_usw2" {
  provider = aws.uswest2
  enabled  = true
}

module "security_hub_event_producer" {
  providers                         = { aws = aws.euwest1 }
  source                            = "git@github.com:Flutter-Global/dtpl-terraform-modules.git//modules/shared/security_hub_workload"
  event_broker_arn_security_account = var.event_broker_arn
  service_name                      = local.service_name
}

resource "aws_s3_account_public_access_block" "block_s3_public_access" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "restrict_default_sg" {
  source = "git@github.com:Flutter-Global/dtpl-terraform-modules.git//modules/network/default_sg_restrict"
  providers = {
    aws         = aws
    aws.euwest1 = aws.euwest1
  }
}

###### IAM role to be assumed from lambda function to describe data-sensitivity check config rule

resource "aws_iam_role" "data_sensitivity_role" {
  name               = "data-sensitivity-role"
  assume_role_policy = file("./iam_policies/allow_assume_data_sens_tag.json")
  tags               = local.tags
}

resource "aws_iam_policy" "data_sensitivity_role_policy" {
  name   = "data-sensitivity-role"
  policy = file("./iam_policies/data_sensitivity_role_policy.json")
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "data_sensitivity_role_attachment" {
  role       = aws_iam_role.data_sensitivity_role.name
  policy_arn = aws_iam_policy.data_sensitivity_role_policy.arn
}

############################################
# Budgets role used to gain budgets values #
############################################

resource "aws_iam_role" "budgets_role" {
  name               = "budgets-role"
  assume_role_policy = file("./iam_policies/allow_assume_budgets_role.json")
  tags               = local.tags
}

resource "aws_iam_policy" "budgets_role_policy" {
  name   = "budgets-role-policy"
  policy = file("./iam_policies/budgets_role_policy.json")
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "budgets_role_attachment" {
  role       = aws_iam_role.budgets_role.name
  policy_arn = aws_iam_policy.budgets_role_policy.arn
}