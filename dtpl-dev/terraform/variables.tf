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