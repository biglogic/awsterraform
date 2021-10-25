variable "configuration" {
    type = map(object({
                application_name = string
                ami = string
                no_of_instances = string
                instance_type = string
                subnet_id = string
                vpc_security_group_ids = list(string)
    })) 
    default = {
               app1 = {
                application_name = "GritfyApp-dev",
                ami = "ami-03d5c68bab01f3496",
                no_of_instances = "2",
                instance_type = "t2.medium",
                subnet_id = "subnet-027ee1142a2b96b2f",
                vpc_security_group_ids = ["sg-0195185264086a144"]
               },
               app2 = {
                application_name = "GritfyApp-dev",
                ami = "ami-090717c950a5c34d3",
                no_of_instances = "2",
                instance_type = "t2.medium",
                subnet_id = "subnet-027ee1142a2b96b2f",
                vpc_security_group_ids = ["sg-0195185264086a144"]
               }
              }
  }

variable "sg" {
  type = map(object({
       vpcid = string 
       ingress_description = string
       ingress_fromport = number
       ingress_toport = number
       ingress_protocal = string
       cidr_blocks = list(string)
  }))
  default = {
          app1 = {
              vpcid = "vpc-01a81e1e2663cce8a"
              ingress_description =  "test" ,
              ingress_fromport = 22,
              ingress_toport = 22,
              ingress_protocal =  "tcp",
              cidr_blocks = ["0.0.0.0/0"]
          },
          app2 = {
            vpcid = "vpc-01a81e1e2663cce8a"
            ingress_description =  "test" ,
            ingress_fromport = 0,
            ingress_toport = 0,
            ingress_protocal =  "-1",
            cidr_blocks = ["0.0.0.0/0"]
          }
  }

}  