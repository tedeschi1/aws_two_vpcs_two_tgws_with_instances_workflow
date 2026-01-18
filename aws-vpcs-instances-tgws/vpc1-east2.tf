data "aws_availability_zones" "east2" {
  provider = aws.east2
  state = "available"
}

resource "aws_vpc" "vpc1_east2" {
    cidr_block = "10.3.0.0/21"
    provider = aws.east2
    tags = {
        Name = "vpc1_east2"
    }
}

resource "aws_subnet" "vpc1_east2_subnets" {
    vpc_id = aws_vpc.vpc1_east2.id
    provider = aws.east2
    count  = length(var.vpc1_east2_subnet_cidrs)
    cidr_block = var.vpc1_east2_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.east2.names[count.index]
    tags = {
        Name = "vpc1_east2_subnet${count.index + 1}"
    }
}

resource "aws_internet_gateway" "vpc1_east2_igw" {
    vpc_id = aws_vpc.vpc1_east2.id
    provider = aws.east2
    tags = {
        Name = "vpc1_east2_igw"
    }
}

resource "aws_route_table" "vpc1_east2_public_rtb" {
    vpc_id = aws_vpc.vpc1_east2.id
    provider = aws.east2

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc1_east2_igw.id
    }
    route {
        cidr_block = "10.1.0.0/21"
        gateway_id = aws_ec2_transit_gateway.us_east2_hub.id
        depends_on = [time_sleep.wait_for_network_mesh]
    }

    tags = {
        Name = "vpc1_east2_public_rtb"
    }

    depends_on = [aws_internet_gateway.vpc1_east2_igw]
}

resource "aws_route_table_association" "vpc1_east2_public_rta" {
   provider = aws.east2
   count = length(aws_subnet.vpc1_east2_subnets)
   subnet_id = aws_subnet.vpc1_east2_subnets[count.index].id
   route_table_id = aws_route_table.vpc1_east2_public_rtb.id
}

resource "aws_security_group" "vpc1_east2_sg" {
  name        = "vpc1_east2_security_group"
  provider = aws.east2
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc1_east2.id
  tags = {
    Name = "vpc1_east2_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_vpc1_east2" {
  security_group_id = aws_security_group.vpc1_east2_sg.id
  provider = aws.east2
  for_each          = toset(["47.186.0.0/16", "198.61.0.0/16"])
  cidr_ipv4         = each.value
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp_vpc1_east2" {
  security_group_id = aws_security_group.vpc1_east2_sg.id
  provider = aws.east2
  for_each          = toset(["10.0.0.0/8"])
  cidr_ipv4         = each.value
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_icmp_out_vpc1_east2" {
  security_group_id = aws_security_group.vpc1_east2_sg.id
  provider          = aws.east2
  for_each          = toset(["10.0.0.0/8"])
  cidr_ipv4         = each.value
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1    
}
