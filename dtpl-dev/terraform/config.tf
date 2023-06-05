resource "aws_config_config_rule" "required_tags_data_sensitivity" {
  name        = "data-sensitivity-tag-check"
  provider    = aws.euwest1
  description = "Checks if resources that are storing or processing any kind of data are tagged with the DataSensitivity tag key with any of the values."

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  scope {
    compliance_resource_types = var.resource_types_with_memory
  }

  input_parameters = jsonencode(var.tags_for_evaluation)
}

resource "aws_iam_role" "required_tags_data_sensitivity" {
  name               = "${local.service_name}-data-sens-tag-rule"
  assume_role_policy = templatefile("${path.module}/iam_policies/allow_assume_config.json", {})
}

resource "aws_iam_role_policy" "required_tags_data_sensitivity" {
  name   = "${local.service_name}-data-sens-tag-rule"
  role   = aws_iam_role.required_tags_data_sensitivity.id
  policy = templatefile("${path.module}/iam_policies/data_sens_tag_config_rule_policy.json", {})
}