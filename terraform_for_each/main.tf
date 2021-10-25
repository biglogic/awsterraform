provider "aws" {
    profile = "atul"
    region  = "us-west-2"
  
}

# locals {
#   serverconfig = [
#     for srv in var.configuration : [
#       for i in range(1, srv.no_of_instances+1) : {
#         instance_name = "${srv.application_name}-${i}"
#         instance_type = srv.instance_type
#         subnet_id   = srv.subnet_id
#         ami = srv.ami
#         security_groups = srv.vpc_security_group_ids
#       }
#     ]
#   ]
# }]

resource "aws_security_group" "sg"  {
  for_each = var.sg   
  vpc_id      = each.value["vpcid"]

  ingress  {
    description = each.value["ingress_description"]
    from_port   = each.value["ingress_fromport"]
    to_port     = each.value["ingress_toport"]
    protocol    = each.value["ingress_protocal"]
    cidr_blocks = each.value["cidr_blocks"]
  }


}

resource "aws_instance" "name" {
   for_each = var.configuration 
   ami = each.value["ami"]
   instance_type = each.value["instance_type"]
   vpc_security_group_ids = [aws_security_group.sg[each.key].id ]
   subnet_id = each.value["subnet_id"]
   tags= {
        Name = each.value["application_name"]
   }
 
}