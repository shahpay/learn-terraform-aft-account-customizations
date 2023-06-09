variable disabled_nis_control_all_region {
  type = map(string)
  default = {
    nis_apigateway_4       =   "APIGateway.3"
    nis_apigateway_5       =   "APIGateway.4"
    nis_apigateway_5       =   "APIGateway.9"
    nis_autoscaling_1      =   "AutoScaling.1"
    nis_autoscaling_2      =   "AutoScaling.2"
    nis_autoscaling_4      =   "AutoScaling.4"
    nis_autoscaling_6      =   "AutoScaling.6" 
    nis_autoscaling_9      =   "AutoScaling.9"
    nis_cloudformation_1   =   "CloudFormation.1"  
    nis_dynamodb_1         =   "DynamoDB.1"
    nis_dynamodb_2         =   "DynamoDB.2"
    nis_ec2_10             =   "EC2.10"
    nis_ec2_6              =   "EC2.6"
    nis_ecr_1              =   "ECR.1"
    nis_ecr_3              =   "ECR.3"
    nis_ecs_12             =   "ECS.12"
    nis_efs_2              =   "EFS.2"
    nis_elasticbeanstalk_1 =   "ElasticBeanstalk.1"
    nis_elb_10             =   "ELB.10"
    nis_elb_12             =   "LB.12"
    nis_elb_13             =   "ELB.13"
    nis_elb_14             =   "ELB.14"
    nis_elb_7              =   "ELB.7"
    nis_elb_9              =   "ELB.9"
    nis_es_4               =   "ES.4"
    nis_es_6               =   "ES.6"
    nis_es_7               =   "ES.7"
    nis_lambda_5           =   "Lambda.5"
    nis_networkfirewall_6  =   "NetworkFirewall.6"
    nis_opensearch_6       =   "Opensearch.6"
    nis_rds_11             =   "RDS.11"
    nis_rds_13             =   "RDS.13"
    nis_rds_14             =   "RDS.14"
    nis_rds_15             =   "RDS.15"
    nis_rds_16             =   "RDS.16"
    nis_rds_17             =   "RDS.17"
    nis_rds_24             =   "RDS.24"
    nis_rds_25             =   "RDS.25"
    nis_rds_5              =   "RDS.5"
    nis_redshift_3         =   "Redshift.3"
    nis_s3_10              =   "S3.10"
    nis_s3_13              =   "S3.13"
    nis_sns_2              =   "SNS.2"
    nis_dynamodb_4         =   "DynamoDB.4"
    nis_ec2_28             =   "EC2.28"
    nis_elb_16             =   "ELB.16"
    nis_lambda_3           =   "Lambda.3"
    nis_rds_26             =   "RDS.26"
    nis_s3_14              =   "S3.14"
    nis_s3_15              =   "S3.15"
    nis_s3_7               =   "S3.7"

}
}

variable enabled_nis_control_all_region {
  type = map(string)
  default = {}
}

variable enabled_nis_control_useast1 {
  type = map(string)
  default = {}
}

variable enabled_nis_control_useast2 {
  type = map(string)
  default = {}
}

variable enabled_nis_control_uswest2 {
  type = map(string)
  default = {}
}

variable enabled_nis_control_cacentral1 {
  type = map(string)
  default = {}
}

variable enabled_nis_control_eucentral1 {
  type = map(string)
  default = {}
}

variable enabled_nis_control_euwest1 {
  type = map(string)
  default = {}
}

variable enabled_nis_control_euwest2 {
  type = map(string)
  default = {}
}
