####################################
# Common Variables
####################################

variable "platform" {
  description = "Name of the project"
  default     = "dtpl"
}

variable "project" {
  description = "Name of the project"
  default     = "nonprod-aft"
}

variable "region" {
  description = "AWS region to build in"
  default     = "eu-west-1"
}

variable "tribe" {
  description = "The tribe this resource belongs to"
  default     = "Data And Analytics"
}

variable "cost_center" {
  description = "Cost center"
  default     = "Data And Analytics"
}

variable "account_map" {
  description = "Map of accounts and numbers"
  default = {
    "28442083888" : "dtpl-core-datalake-processing-intg",
    "66487289869" : "dtpl-sandbox-01",
    "69726535728" : "dtpl-dev-platform-mvp",
    "84107536612" : "dtpl-sandbox-05",
    "104556087102" : "dtpl-core-msk-intg",
    "107229675248" : "dtpl-security-dev",
    "107429416015" : "dtpl-prod",
    "117794803000" : "dtpl-meco-build-lab-intg",
    "127632347086" : "sts-root",
    "141186643827" : "sts-snowplow-dev",
    "178440194215" : "dtpl-core-intg",
    "205664846262" : "dtpl-meco-build-lab-dev",
    "245815655620" : "dtpl-logging",
    "246659685798" : "dtpl-core-datalake-storage-dev",
    "298151634641" : "dtpl-reg-reporting-ssc-prep-prod",
    "328211912100" : "dtpl-reg-reporting-ssc-dev-intg",
    "345212475956" : "dtpl-sandbox-07",
    "404519054608" : "dtpl-sandbox-02",
    "414610866689" : "dtpl-core-dev",
    "423432601656" : "dtpl-management",
    "424543916521" : "dtpl-core-msk-dev",
    "472017451031" : "dtpl-core-customer-profile-intg",
    "474146285433" : "dtpl-core-datalake-processing-dev",
    "478163696620" : "dtpl-dev",
    "523884154443" : "dtpl-sandbox-04",
    "534805103759" : "dtpl-preprod",
    "557273839517" : "dtpl-sandbox-00",
    "584305994979" : "dtpl-sandbox-06",
    "592982365757" : "dtpl-intg",
    "594056413359" : "dtpl-sandbox-03",
    "656846120821" : "dtpl-core-customer-profile-dev",
    "668403860355" : "dtpl-logging-dev",
    "679627425763" : "dtpl-customer-dev",
    "697928078949" : "dtpl-reg-reporting-prod",
    "751851806841" : "dtpl-security",
    "823554533179" : "dtpl-core-datalake-storage-intg",
    "883031630176" : "sts-snowplow",
    "907437653097" : "dtpl-customer-intg",
    "951044653402" : "dtpl-reg-reporting-intg",
    "957027455813" : "dtpl-reg-reporting-preprod",
    "960022976665" : "dtpl-intg-platform-mvp",
  }
}

variable "subscriptions" {
  description = "SNS subscriptions"
  default = {
    "dtpl-aws-data-platfor-aaaah6mlful6lby4icfcsdsle4@flutter.org.slack.com" = "email"
  }
}


####################################
## Workload Specific Variables
####################################

variable "budget_capacity" {
  description = "The maximum amount of money that can be spent in a sandbox account"
  default     = "5000" #should be changed with custom fields, so we can have different budgets limits for the different accounts.
}

variable "hook_url_notifications" {
  description = "Webhook URL for the slack notification channel"
  type        = string
  default     = "https://hooks.slack.com/services/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"
}

variable "hook_url_alerts" {
  description = "Webhook URL for the slack alerts channel"
  type        = string
  default     = "https://hooks.slack.com/services/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"
}

variable "slack_channel_alerts" {
  description = "Slack channel for AWS alerts"
  type        = string
  default     = "da-ps-dtpl-alerts"
}

variable "slack_channel_notifications" {
  description = "Slack channel for AWS notifications"
  type        = string
  default     = "da-ps-dtpl-notifications"
}

variable "email_topic_endpoint" {
  description = "Endpoint of the email topic"
  type        = string
  default     = "da-platform-services-dtpl-alerts@pokerstarsint.com"
}

variable "pagerduty_integration_url" {
  description = "PagerDuty integration URL for the sns topic subscription"
  type        = string
  default     = "https://events.pagerduty.com/integration/8d909bea16214800c0375df7e7e93212/enqueue"
}

variable "resource_types_with_memory" {
  description = "Resources that are storing or processing any kind of data (currently used for the data-sensitivity check rule)"
  type        = list(string)
  default = [
    "AWS::Athena::DataCatalog",
    "AWS::Athena::WorkGroup",
    "AWS::DynamoDB::Table",
    "AWS::EC2::Instance",
    "AWS::EC2::Volume",
    "AWS::ECR::Repository",
    "AWS::ECR::PublicRepository",
    "AWS::ECS::Cluster",
    "AWS::EFS::FileSystem",
    "AWS::EKS::Cluster",
    "AWS::Elasticsearch::Domain",
    "AWS::OpenSearch::Domain",
    "AWS::Kinesis::Stream",
    "AWS::Kinesis::StreamConsumer",
    "AWS::KinesisAnalyticsV2::Application",
    "AWS::MSK::Cluster",
    "AWS::Redshift::Cluster",
    "AWS::Redshift::ClusterSnapshot",
    "AWS::RDS::DBInstance",
    "AWS::RDS::DBSnapshot",
    "AWS::RDS::DBCluster",
    "AWS::RDS::DBClusterSnapshot",
    "AWS::RDS::GlobalCluster",
    "AWS::SageMaker::CodeRepository",
    "AWS::SageMaker::Model",
    "AWS::SageMaker::NotebookInstance",
    "AWS::SageMaker::TrainingJob",
    "AWS::SageMaker::Endpoint",
    "AWS::S3::Bucket",
    "AWS::ElastiCache::CacheCluster",
    "AWS::Lambda::Function",
    "AWS::EMR::Cluster",
    "AWS::Glue::Job",
    "AWS::Glue::Database",
    "AWS::Glue::Table",
    "AWS::Glue::Crawler",
    "AWS::Glue::Trigger",
    "AWS::KinesisFirehose::DeliveryStream",
    "AWS::KinesisAnalytics::Application",
    "AWS::StepFunctions::StateMachine",
    "AWS::Batch::JobDefinition",
    "AWS::Batch::JobQueue",
    "AWS::Batch::ComputeEnvironment",
    "AWS::LakeFormation::Permissions",
    "AWS::LakeFormation::DataLakeSettings",
    "AWS::FSx::FileSystem",
    "AWS::Neptune::DBInstance",
    "AWS::Neptune::DBCluster",
    "AWS::Transfer::User",
    "AWS::Transfer::Server"
  ]
}

variable "tags_for_evaluation" {
  description = "Tags to be added in the required-tags config rule for compliance evaluation"
  default = {
    tag1Key : "DataSensitivity",
    tag1Value : "public,internal,customer-data,customer-metaData,PCI-data"
  }
}

####################################
# Locals
####################################

locals {
  service_name = "${var.platform}-${var.project}"
  tags = {
    Platform   = var.platform
    Project    = var.project
    Region     = var.region
    Tribe      = var.tribe
    CostCenter = var.cost_center
    AFT        = "true"
    Locked     = "true"
  }
}

####################################
# Management account number
# that needs to assume ci roles
# and roles for local dev using SSO
####################################
variable "account_id" {
  default = "423432601656"
}

variable "sso_suffix" {
  default = "10f53e1e950fee61"
}

####################################
# accessing custom field from aft-account-request
####################################
data "aws_ssm_parameter" "budget_limit" {
  name = "/aft/account-request/custom-fields/budget"
}

variable "event_broker_arn" {
  default = "arn:aws:events:eu-west-1:751851806841:event-bus/dtpl-sec-prod-event-broker"
}
