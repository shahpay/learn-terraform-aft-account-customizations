variable disabled_control_all {
  type = list(object({
     control_id = string
  }))
  default = [{
    control_id = "APIGateway.4"
  }]
}

variable enabled_control_all {
  type = list(object({
    #  region = string,
    # #  name = string,
     control_id = string
    #  disabled_reason = string 
  }))
  default = [{
    control_id = "APIGateway.4"
  }]
}