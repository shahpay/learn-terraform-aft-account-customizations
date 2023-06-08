variable disabled_nis_control_all_region {
  type = map(string)
  default = {
    nis_apigateway_4 = "APIGateway.4"
    nis_apigateway_5 = "APIGateway.5"
  }
}

variable enabled_nis_control_all_region {
  type = map(string)
  # default = {
  #   nis_apigateway_4 = "APIGateway.4"
  # }
}