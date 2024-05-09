variable "launch-temp" {
  type = string
  default = "web"
}

variable "chassis" {
  type = string
  default = "t2.micro"
}

data "aws_ami" "web-aurora" {
    most_recent = true
    owners = [ "234696672730" ]
    filter {
      name = "name"
      values = [ "web-aurora" ]
    }
}

variable "sg_id" {
  
}

variable "subnet_ids" {
  
}

variable "vpc_id" {
  
}

variable "vpc_name" {
  
}