terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "atul"
  region  = "us-west-2"
}

resource "aws_vpc" "prod_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
    Name = "atulvpc"
  }
}

resource "aws_subnet" "subnet_public" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-2a"
    tags = {
       Name = "aksubnetpub"
  }

}

resource "aws_subnet" "subnet_public_1" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-west-2b"
     tags = {
        Name = "aksubnetpub-1"
  }

   
}

resource "aws_subnet" "subnet_pvt" {
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-west-2a"
     tags = {
        Name = "aksubnetpvt"
  }

    
}

resource "aws_subnet" "subnet_pvt_1" {
    vpc_id =  aws_vpc.prod_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-west-2b"
     tags = {
         Name = "aksubnetpvt-1"
  }

   
}


resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.prod_vpc.id
     tags = {
          Name = "akigw"
  }

    
}

resource "aws_route_table" "public_routable" {
    vpc_id = aws_vpc.prod_vpc.id

    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"         //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.myigw.id
    }
    tags = {
       Name = "routetablepub"
  }

    
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.public_routable.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_public_1.id
  route_table_id = aws_route_table.public_routable.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_gateway.id
    subnet_id = aws_subnet.subnet_public.id
    tags = {
       Name = "aknatgw"
  }

}
resource "aws_route_table" "pvt_routable" {
    vpc_id = aws_vpc.prod_vpc.id

    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"         //CRT uses this IGW to reach internet
        nat_gateway_id = aws_nat_gateway.nat_gateway.id 
    }
    tags = {
       Name = "routetablepvt"
  }


     
}

resource "aws_route_table_association" "pvt_1" {
  subnet_id      = aws_subnet.subnet_pvt.id
  route_table_id = aws_route_table.pvt_routable.id
}
resource "aws_route_table_association" "pvt_2" {
  subnet_id      = aws_subnet.subnet_pvt_1.id
  route_table_id = aws_route_table.pvt_routable.id
}


resource "aws_security_group" "aksecurity" {
  name        = "aksecurity"
  description = "Allow ssh"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress  {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
         from_port   = 0
         to_port     = 0
         protocol    = "-1"
         cidr_blocks = ["0.0.0.0/0"]
       }


  tags ={
     Name = "aksecurity"
 }
}

resource "aws_instance" "pivot_gocd_agent" {
  ami           = "ami-07dd19a7900a1f049"
  instance_type = "t2.medium"
  key_name = "amazonkey"
  subnet_id = aws_subnet.subnet_public.id
  vpc_security_group_ids = [ aws_security_group.aksecurity.id ]
  tags = {
    Name = "jumpbox"
  }
}

resource "aws_instance" "pvt" {
  ami           = "ami-07dd19a7900a1f049"
  instance_type = "t2.medium"
  key_name = "amazonkey"
  subnet_id = aws_subnet.subnet_pvt.id
  vpc_security_group_ids = [ aws_security_group.aksecurity.id ]
  tags = {
    Name = "pvtinstance"
  }
}

resource "aws_alb" "alb" {  
  name            = "alb"  
  subnets         = [aws_subnet.subnet_public.id,aws_subnet.subnet_public_1.id]
  security_groups = [aws_security_group.aksecurity.id]
  internal        = "false"  
  

  tags = {    
    Name  = "elb"    
  }   
  
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.arn
  port              = "80"
  protocol          = "HTTP"
}


