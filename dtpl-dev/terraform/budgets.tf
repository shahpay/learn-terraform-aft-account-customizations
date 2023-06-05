#########################################################
####                 NonProd Budget                  ####
#########################################################

resource "aws_budgets_budget" "monthly_budget" {
  provider     = aws.euwest1
  name         = "${local.service_name}-budget"
  budget_type  = "COST"
  limit_amount = data.aws_ssm_parameter.budget_limit.value
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 50
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.budgets_warning_topic.arn]
  }
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 90
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.budgets_warning_topic.arn]
  }
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 50
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budgets_warning_topic.arn]

  }
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 90
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budgets_critical_topic.arn]
  }
}

###########################################################
################### Budgets2Slack Lambda ##################
###########################################################

data "archive_file" "budgets2slack" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/budgets2slack"
  output_path = "${path.module}/temp/budgets2slack.zip"
}

resource "aws_lambda_function" "budgets2slack" {
  provider         = aws.euwest1
  filename         = data.archive_file.budgets2slack.output_path
  function_name    = "${local.service_name}-lambda-budgets2slack"
  role             = aws_iam_role.budgets2slack_role.arn
  handler          = "index.lambda_handler"
  source_code_hash = filemd5(data.archive_file.budgets2slack.output_path)
  description      = "Lambda function to deliver budgets alerts to Slack webhook URL"

  runtime = "python3.9"
  timeout = 300

  environment {
    variables = {
      environment  = terraform.workspace
      slackChannel = var.slack_channel_alerts
      slackUrl     = var.hook_url_alerts
    }
  }

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.service_name}-lambda-budgets2slack" })
  )
}

resource "aws_lambda_permission" "warning_sns_budgets" {
  provider      = aws.euwest1
  statement_id  = "AllowExecutionFromWarningSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.budgets2slack.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.budgets_warning_topic.arn
}

resource "aws_lambda_permission" "critical_sns_budgets" {
  provider      = aws.euwest1
  statement_id  = "AllowExecutionFromNotificationSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.budgets2slack.function_name
  principal     = "budgets.amazonaws.com"
  source_arn    = aws_sns_topic.budgets_critical_topic.arn
}

resource "aws_iam_role" "budgets2slack_role" {
  provider = aws.euwest1
  name     = "${local.service_name}-lambda-budgets2slack"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.service_name}-lambda-budgets2slack" })
  )
}

resource "aws_iam_role_policy" "budgets2slack_policy" {
  provider = aws.euwest1
  name     = "${local.service_name}-lambda-budgets2slack"
  role     = aws_iam_role.budgets2slack_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

###########################################################
################## Budgets Warning Topic ##################
###########################################################

resource "aws_sns_topic" "budgets_warning_topic" {
  provider        = aws.euwest1
  name            = "${local.service_name}-budgets-warning-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  tags = merge(
    local.tags,
    tomap({ Name = "${local.service_name}-budgets-warning-topic" })
  )
}
resource "aws_sns_topic_policy" "budget_warning_topic_policy" {
  provider = aws.euwest1
  arn      = aws_sns_topic.budgets_warning_topic.arn
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AWSBudgets-notification-1",
        "Effect": "Allow",
        "Principal": {
            "Service": "budgets.amazonaws.com"
        },
        "Action": "SNS:Publish",
        "Resource": "${aws_sns_topic.budgets_warning_topic.arn}"
    }
  ]
}
EOF
}

###########################################################
################## Budgets Critical Topic #################
###########################################################

resource "aws_sns_topic" "budgets_critical_topic" {
  provider        = aws.euwest1
  name            = "${local.service_name}-budgets-critical-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  tags = merge(
    local.tags,
    tomap({ Name = "${local.service_name}-budgets-critical-topic" })
  )
}
resource "aws_sns_topic_policy" "budget_critical_topic_policy" {
  provider = aws.euwest1
  arn      = aws_sns_topic.budgets_critical_topic.arn
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AWSBudgets-notification-1",
        "Effect": "Allow",
        "Principal": {
            "Service": "budgets.amazonaws.com"
        },
        "Action": "SNS:Publish",
        "Resource": "${aws_sns_topic.budgets_critical_topic.arn}"
    }
  ]
}
EOF
}

#########################################
##### Budgets topics subscripitions #####
#########################################

resource "aws_sns_topic_subscription" "budgets_warning_topic_lambda_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.budgets_warning_topic.arn
  protocol               = "lambda"
  endpoint               = aws_lambda_function.budgets2slack.arn
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "budgets_warning_topic_email_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.budgets_warning_topic.arn
  protocol               = "email"
  endpoint               = var.email_topic_endpoint
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "budgets_critical_topic_https_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.budgets_critical_topic.arn
  protocol               = "https"
  endpoint               = var.pagerduty_integration_url
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "budgets_critical_topic_email_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.budgets_critical_topic.arn
  protocol               = "email"
  endpoint               = var.email_topic_endpoint
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "budgets_critical_topic_lambda_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.budgets_critical_topic.arn
  protocol               = "lambda"
  endpoint               = aws_lambda_function.budgets2slack.arn
  endpoint_auto_confirms = true
}
