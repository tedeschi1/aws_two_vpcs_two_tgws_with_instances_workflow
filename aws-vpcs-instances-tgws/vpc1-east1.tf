resource "aws_vpc" "vpc1_east1" {
    cidr_block = "10.1.0.0/21"
    tags = {
        Name = "vpc1_east1"
    }

}

resource "aws_subnet" "vpc1_east1_subnets" {
    vpc_id = aws_vpc.vpc1_east1.id
    for_each = var.vpc1_subnet_config
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    tags = {
        Name = each.key
    }
}

resource "aws_route_table" "vpc1_east1_public_rtb" {
    vpc_id = aws_vpc.vpc1_east1.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc1_east1_igw.id
    }

    route {
        cidr_block = "10.3.0.0/21"
        transit_gateway_id = aws_ec2_transit_gateway.us_east1_hub.id
    }
    tags = {
        Name = "vpc1_east1_public_rtb"
    }

    depends_on = [ aws_internet_gateway.vpc1_east1_igw ]
}

resource "aws_internet_gateway" "vpc1_east1_igw" {
    vpc_id = aws_vpc.vpc1_east1.id
    tags = {
        Name = "vpc1_east_igw"
    }
}

resource "aws_route_table_association" "vpc1_east1" {
    for_each = var.vpc1_subnet_config
    subnet_id = aws_subnet.vpc1_east1_subnets[each.key].id
    route_table_id = aws_route_table.vpc1_east1_public_rtb.id
}

resource "aws_security_group" "vpc1_east1_sg" {
  name        = "vpc1_east1_security_group"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc1_east1.id
  tags = {
    Name = "vpc1_east1_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.vpc1_east1_sg.id
  for_each          = toset(["47.186.0.0/16", "198.61.0.0/16"])
  cidr_ipv4         = each.value
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp_vpc1" {
  security_group_id = aws_security_group.vpc1_east1_sg.id
  for_each          = toset(["10.0.0.0/8"])
  cidr_ipv4         = each.value
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_icmp_out_vpc1_east1" {
  security_group_id = aws_security_group.vpc1_east1_sg.id
  for_each          = toset(["10.0.0.0/8"])
  cidr_ipv4         = each.value
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1    
}

output "vpc1_east1_subnet0_id" {
  value = aws_subnet.vpc1_east1_subnets["vpc1_subnet1"].id
}

output "vpc1_east1_subnet1_id" {
  value = aws_subnet.vpc1_east1_subnets["vpc1_subnet2"].id
}

