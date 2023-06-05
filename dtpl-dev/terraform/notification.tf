###########################################################
#################### Critical Topic #######################
###########################################################

resource "aws_sns_topic" "critical_topic" {
  provider        = aws.euwest1
  name            = "${local.service_name}-sns-topic-critical"
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
    tomap({ Name = "${local.service_name}-sns-topic-critical" })
  )
}

resource "aws_sns_topic_policy" "critical_topic_policy" {
  provider = aws.euwest1
  arn      = aws_sns_topic.critical_topic.arn
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "CloudWatch to SNS",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudwatch.amazonaws.com"
        },
        "Action": "SNS:Publish",
        "Resource": "${aws_sns_topic.critical_topic.arn}"
    }
  ]
}
EOF
}

###########################################################
##################### Warning Topic #######################
###########################################################

resource "aws_sns_topic" "warning_topic" {
  provider        = aws.euwest1
  name            = "${local.service_name}-sns-topic-warning"
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
    tomap({ Name = "${local.service_name}-sns-topic-warning" })
  )
}

resource "aws_sns_topic_policy" "warning_topic_policy" {
  provider = aws.euwest1
  arn      = aws_sns_topic.warning_topic.arn
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "CloudWatch to SNS",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudwatch.amazonaws.com"
        },
        "Action": "SNS:Publish",
        "Resource": "${aws_sns_topic.warning_topic.arn}"
    }
  ]
}
EOF
}

###########################################################
################## Notification Topic #####################
###########################################################

resource "aws_sns_topic" "notification_topic" {
  provider        = aws.euwest1
  name            = "${local.service_name}-sns-topic-notification"
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
    tomap({ Name = "${local.service_name}-sns-topic-notification" })
  )
}

resource "aws_sns_topic_policy" "notification_topic_policy" {

  provider = aws.euwest1
  arn      = aws_sns_topic.notification_topic.arn
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "CloudWatch to SNS",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudwatch.amazonaws.com"
        },
        "Action": "SNS:Publish",
        "Resource": "${aws_sns_topic.notification_topic.arn}"
    }
  ]
}
EOF
}

###########################################################
##################### Subscriptions #######################
###########################################################

resource "aws_sns_topic_subscription" "notification_topic_https_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.notification_topic.arn
  protocol               = "lambda"
  endpoint               = aws_lambda_function.sns2slack_notifications.arn
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "notification_topic_email_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.notification_topic.arn
  protocol               = "email"
  endpoint               = var.email_topic_endpoint
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "warning_topic_https_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.warning_topic.arn
  protocol               = "lambda"
  endpoint               = aws_lambda_function.sns2slack_alerts.arn
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "warning_topic_email_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.warning_topic.arn
  protocol               = "email"
  endpoint               = var.email_topic_endpoint
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "critical_topic_https_pagerduty_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.critical_topic.arn
  protocol               = "https"
  endpoint               = var.pagerduty_integration_url
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "critical_topic_https_slack_subscription" {
  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.critical_topic.arn
  protocol               = "lambda"
  endpoint               = aws_lambda_function.sns2slack_alerts.arn
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "critical_topic_email_subscription" {

  provider               = aws.euwest1
  topic_arn              = aws_sns_topic.critical_topic.arn
  protocol               = "email"
  endpoint               = var.email_topic_endpoint
  endpoint_auto_confirms = true
}

#######################################################
################### SNS2Slack Notifications Lambda ##################
#######################################################

data "archive_file" "sns2slack_notifications" {

  type        = "zip"
  source_dir  = "${path.module}/lambda/sns2slack_notifications"
  output_path = "${path.module}/temp/sns2slack_notifications.zip"
}

resource "aws_lambda_function" "sns2slack_notifications" {

  provider         = aws.euwest1
  filename         = data.archive_file.sns2slack_notifications.output_path
  function_name    = "${local.service_name}-lambda-sns2slack_notifications"
  role             = aws_iam_role.sns2slack_role_nofitications.arn
  handler          = "index.lambda_handler"
  source_code_hash = filemd5(data.archive_file.sns2slack_notifications.output_path)
  description      = "Lambda function to deliver Notifications SNS messages to Slack webhook URL"

  runtime = "python3.9"
  timeout = 300

  environment {
    variables = {
      environment  = terraform.workspace
      slackChannel = var.slack_channel_notifications
      slackUrl     = var.hook_url_notifications
    }
  }

  tags = merge(
    local.tags,
    tomap({ "Name" = "${local.service_name}-lambda-sns2slack-notifications" })
  )
}

resource "aws_lambda_permission" "notification_sns" {
  provider      = aws.euwest1
  statement_id  = "AllowExecutionFromNotificationSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns2slack_notifications.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification_topic.arn
}

resource "aws_iam_role" "sns2slack_role_nofitications" {

  provider = aws.euwest1
  name     = "${local.service_name}-lambda-sns2slack-notifications"

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
    tomap({ "Name" = "${local.service_name}-lambda-sns2slack-notifications" })
  )
}

resource "aws_iam_role_policy" "sns2slack_policy_notifications" {

  provider = aws.euwest1
  name     = "${local.service_name}-lambda-sns2slack-notifications"
  role     = aws_iam_role.sns2slack_role_nofitications.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

#######################################################
################### SNS2Slack Alerts Lambda ##################
#######################################################

data "archive_file" "sns2slack_alerts" {

  type        = "zip"
  source_dir  = "${path.module}/lambda/sns2slack_alerts"
  output_path = "${path.module}/temp/sns2slack_alerts.zip"
}

resource "aws_lambda_function" "sns2slack_alerts" {

  provider         = aws.euwest1
  filename         = data.archive_file.sns2slack_alerts.output_path
  function_name    = "${local.service_name}-lambda-sns2slack_alerts"
  role             = aws_iam_role.sns2slack_role_alerts.arn
  handler          = "index.lambda_handler"
  source_code_hash = filemd5(data.archive_file.sns2slack_alerts.output_path)
  description      = "Lambda function to deliver Alerts SNS messages to Slack webhook URL"

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
    tomap({ "Name" = "${local.service_name}-lambda-sns2slack-alerts" })
  )
}

resource "aws_lambda_permission" "critical_sns" {

  provider      = aws.euwest1
  statement_id  = "AllowExecutionFromCriticalSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns2slack_alerts.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.critical_topic.arn
}

resource "aws_lambda_permission" "warning_sns" {

  provider      = aws.euwest1
  statement_id  = "AllowExecutionFromWarningSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns2slack_alerts.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.warning_topic.arn
}

resource "aws_iam_role" "sns2slack_role_alerts" {
  name = "${local.service_name}-lambda-sns2slack-alerts"

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
    tomap({ "Name" = "${local.service_name}-lambda-sns2slack-alerts" })
  )
}

resource "aws_iam_role_policy" "sns2slack_policy_alerts" {
  name = "${local.service_name}-lambda-sns2slack-alerts"
  role = aws_iam_role.sns2slack_role_alerts.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
