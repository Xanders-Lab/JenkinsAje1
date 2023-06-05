# 01 - Add provider
provider "aws" {
    region = "us-east-1"
  
  
}

# 02 - Add terraform block
/* terraform {
  backend "s3" {}
} */
# 1 - Create VPC
resource "aws_vpc" "Dev_vpc" {
    
    cidr_block =var.vpc_cidr[0]
    tags = {

      Name=var.vpc_name[0]
      
    }
}

# 3 - Create an internetgateway 
resource "aws_internet_gateway" "Dev_igw" {
    vpc_id = aws_vpc.Dev_vpc.id
    tags = {
        Name="Dev-igw"
    }
}
# 4 - Create two public subnets 
resource "aws_subnet" "public_subnet1" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.Dev_vpc.id
    cidr_block = var.public_subnets[count.index]
    tags = {
        Name="Dev-Pub-Sub${count.index}"
    }
}
# 5 Create two privates subnets 
resource "aws_subnet" "private_subnet1" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.Dev_vpc.id
    cidr_block = var.private_subnets[count.index]
    tags = {
        Name="Dev-Priv-Sub${count.index }"
    }
}
# 6 Create a public route table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.Dev_vpc.id
    tags = {
      Name="Dev-Pub-RT"
    }
}
# 7 Create private route table
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.Dev_vpc.id
    tags = {
      Name="Dev-Priv-RT"
    }
}

# 8 Create public route for public subnets
resource "aws_route" "public_rt_public_subnets" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block =var.pub_dest[0]
    gateway_id = aws_internet_gateway.Dev_igw.id
    
}
resource "aws_route" "Route_4peering" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block =var.pub_dest[1]
   
    vpc_peering_connection_id =aws_vpc_peering_connection.my_peering.id
} 
# 9 - Public subnet association 
resource "aws_route_table_association" "public_rt_public_subnets" {
    route_table_id = aws_route_table.public_rt.id
    count=length(var.public_subnets)
    subnet_id = aws_subnet.public_subnet1[count.index].id
    
}

# 10 - Private subnet association
resource "aws_route_table_association" "private_route_table" {
    route_table_id = aws_route_table.private_rt.id
    count=length(var.private_subnets)
    subnet_id = aws_subnet.private_subnet1[count.index].id
  
}
# 11 Create security Group
resource "aws_security_group" "sg" {
    name = "Dev-SG"
    vpc_id = aws_vpc.Dev_vpc.id
    description = "Dev-SG"
    tags = {
        Name="Dev-sg"
    }
    dynamic "ingress" {
        for_each = var.dev_sg
        iterator = port
        content {
            from_port = port.value
            to_port =port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
      
    }
     egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    

}
# Elastic ip
resource "aws_eip" "eip" {
    count = 1
    vpc = true
    instance = aws_instance.dev_instance[0].id
    tags = {}

}
#12 create an instance
resource "aws_instance" "dev_instance" {
    #count = length(var.public_subnets) 
    count = 1
    subnet_id = aws_subnet.public_subnet1[0].id
     
    ami = var.dev_ami
    instance_type = var.dev_instance
    key_name =var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    
    tags = {
        Name=var.vpc_name[0]
    }

   
    
}
############################################################################################
# VPC 2 network 
resource "aws_vpc" "Prod_vpc" {
    
    cidr_block =var.vpc_cidr2[0]
    tags = {

      Name=var.vpc_name[1]
      
    }
}
# 3 - Create an internetgateway 
resource "aws_internet_gateway" "Prod_igw" {
    vpc_id = aws_vpc.Prod_vpc.id
    tags = {
        Name=var.vpc_name[1]
    }
}
# 4 - Create two public subnets 
resource "aws_subnet" "public_subnet2" {
    count = length(var.public_subnets2)
    vpc_id = aws_vpc.Prod_vpc.id
    cidr_block = var.public_subnets2[count.index]
    tags = {
        Name="Prod-Pub-Sub${count.index}"
    }
}
# 5 Create two privates subnets 
resource "aws_subnet" "private_subnet2" {
    count = length(var.private_subnets2)
    vpc_id = aws_vpc.Prod_vpc.id
    cidr_block = var.private_subnets2[count.index]
    tags = {
        Name="Prod-Priv-Sub${count.index }"
    }
}
# 6 Create a public route table
resource "aws_route_table" "public_rt2" {
    vpc_id = aws_vpc.Prod_vpc.id
    tags = {
      Name="Prod-Pub-RT"
    }
}
# 7 Create private route table
resource "aws_route_table" "private_rt2" {
    vpc_id = aws_vpc.Prod_vpc.id
    tags = {
      Name="Prod-Priv-RT"
    }
}


# Edit route for peering 
resource "aws_route" "Route_4Peering2" {
    route_table_id = aws_route_table.public_rt2.id
    destination_cidr_block =var.pub_dest[2]
    vpc_peering_connection_id =aws_vpc_peering_connection.my_peering.id
    
    #vpc_peering_connection_id =aws_vpc_peering_connection.Prod_vpc_peering_connection.id

} 

# 8 Create public route for public subnets
resource "aws_route" "public_rt_public_subnets2" {
    route_table_id = aws_route_table.public_rt2.id
    destination_cidr_block =var.pub_dest[0]
    gateway_id = aws_internet_gateway.Prod_igw.id
   
}
# 9 - Public subnet association 
resource "aws_route_table_association" "public_rt_public_subnets2" {
    route_table_id = aws_route_table.public_rt2.id
    count=length(var.public_subnets2)
    subnet_id = aws_subnet.public_subnet2[count.index].id
}
# 10 - Private subnet association
resource "aws_route_table_association" "private_route_table2" {
    route_table_id = aws_route_table.private_rt2.id
    count=length(var.private_subnets2)
    subnet_id = aws_subnet.private_subnet2[count.index].id
  
}
# 11 Create security Group
resource "aws_security_group" "sg2" {
    name = "Prod-SG"
    vpc_id = aws_vpc.Prod_vpc.id
    description = "Dev-SG"
    tags = {
        Name="Prod-SG"
    }
   
    dynamic "ingress" {
        for_each = var.dev_sg
        iterator = port
        content {
            from_port = port.value
            to_port =port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
      
    }
     egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    

}
# Elastic ip
resource "aws_eip" "eip2" {
    count = 1
    vpc = true
    instance = aws_instance.dev_instance2[0].id
    tags = {}

}
#12 create an instance
resource "aws_instance" "dev_instance2" {
    #count = length(var.public_subnets) 
    count = 1
    subnet_id = aws_subnet.public_subnet2[0].id
     
    ami = var.dev_ami
    instance_type = var.dev_instance
    key_name =var.key_name
    vpc_security_group_ids = [aws_security_group.sg2.id]
  
    tags = {
        Name=var.vpc_name[1]
        

        
    }
    
    

   
    
}
########################################################################
# Create VPC peering connection
resource "aws_vpc_peering_connection" "my_peering" {
    peer_vpc_id = aws_vpc.Prod_vpc.id
   
    vpc_id=aws_vpc.Dev_vpc.id
    
    auto_accept = true


}
