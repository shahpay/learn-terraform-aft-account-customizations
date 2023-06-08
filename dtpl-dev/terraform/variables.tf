variable enabled_nis_control_all_region {
  type = map(string)
  default = {
    nis_apigateway_4 = "APIGateway.4",
}
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
