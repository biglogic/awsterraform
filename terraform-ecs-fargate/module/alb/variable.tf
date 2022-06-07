variable "vpc_id" {
  
}

variable "vpc_subnets" {
   
}

variable "sg_lb_id" {
   
}

variable "health_check_path" {
  default = "/"
}

variable "app_port" {
  default = 80
}

# variable "listener_rule" {
#   description = "List of parameters for listener_rule"
#   type = list
#   default = ["example.com","example.com.in","example.com.2"]
# }

variable "listener_rule" {
  description = "List of parameters for listener_rule"
  type = list(object({
    listener_arn       = string
    conditions       = string
    value   = list(string)
  }))
  default = [
  {
    listener_arn = "ayx"
    conditions = "path_pattern"
    value = ["/example"]
  },
  # {
  #   listener_arn = "ayx"
  #   conditions = "host_header"
  #   value = ["dynamodb.us-west-1.amazonaws.com"]
  # },
  {
    listener_arn = "ayx"
    conditions = "host_header"
    value = ["dynamodb.us-west-2.amazonaws.com"]
  }]
}

variable "listner_val" {
  type = any
  default = null
}
