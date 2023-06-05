# a create variable for vpc, use list 
variable "vpc_cidr" {
    type = list(string)
    default = ["10.0.0.0/16", "172.0.0.0/24"]
  
}
# Create variable for vpc name
variable "vpc_name" {
    type = list(string)
    default = [ "Dev","Prod" ]
  
}

# Create variable for public subnet
variable "public_subnets" {
    type = list(string)
    default = ["10.0.0.0/24", "10.0.1.0/24"]
}
# Create variable for private subnet
variable "private_subnets" {
    type = list(string)
    default = [ "10.0.2.0/24","10.0.3.0/24" ]
  
}
/* # Varible for availabilty zone
variable "az_name" {
    type = list(string)
    default = [ "value" ]
} */

variable "pub_dest" {
    type=list(string)
    default = ["0.0.0.0/0","172.0.0.0/16","10.0.0.0/16"]
  
}
# variable for Security group
variable "dev_sg" {
    type=list(number)
    default =[80,40,443,22,8080]
  
}
# Variable for instance type and instance name
variable "dev_instance" {
    type=string
    default="t2.micro" 
    
  
}
# variable for  AMI 
variable "dev_ami" {
    type = string
    default = "ami-053b0d53c279acc90"
  
}
variable "key_name" {
    type = string

  
}


###############################################################################################################
# Vpc2 variables
# a create variable for vpc, use list 
variable "vpc_cidr2" {
    type = list(string)
    default = ["172.0.0.0/16"]
  
}

# Variable for internetgeteway Name
variable "igw_name2" {
    type = list(string)
    default = [ "value" ]
}
# Create variable for public subnet
variable "public_subnets2" {
    type = list(string)
    default = ["172.0.0.0/24", "172.0.1.0/24"]
}
# Create variable for private subnet
variable "private_subnets2" {
    type = list(string)
    default = [ "172.0.2.0/24","172.0.3.0/24" ]
  
}
variable "pub-dest2" {
    type=list(string)
    default= ["0.0.0.0/0","10.0.0.0/16"]
  
}
