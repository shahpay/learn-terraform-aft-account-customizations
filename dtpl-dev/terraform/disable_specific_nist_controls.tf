variable disabled_nis_control_all_region {
type = map(string)
default = {
  nis_elb_5    =     ELB.5
  nis_rds_19   =     RDS.19
  nis_rds_20   =     RDS.20
  nis_rds_21   =     RDS.21
  nis_rds_22   =     RDS.22
  nis_rds_7    =     RDS.7
  nis_rds_8    =     RDS.8
  nis_rds_9    =     RDS.9
}
}

module securityhub {
  providers = {
    aws.useast2 = aws.useast2
    aws.uswest2 = aws.uswest2
    aws.cacentral1 = aws.cacentral1
    aws.eucentral1 = aws.eucentral1
    aws.euwest1 = aws.euwest1
    aws.euwest2 = aws.euwest2
}
  source = "./modules/securityhub"
  disabled_nis_control_all_region = var.disabled_nis_control_all_region
}
