resource "aws_ec2_transit_gateway" "us_east1_hub" {
  description = "US Hub for VPC peering"
  provider = aws.east1
  
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "us-east1-hub-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_east1" {
  subnet_ids         = [aws_subnet.vpc1_east1_subnets["vpc1_subnet1"].id, aws_subnet.vpc1_east1_subnets["vpc1_subnet2"].id]
  transit_gateway_id = aws_ec2_transit_gateway.us_east1_hub.id
  vpc_id             = aws_vpc.vpc1_east1.id

  tags = {
    Name = "vpc1-east1-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_route" "to_vpc1_east2_tgw" {
  destination_cidr_block         = "10.3.0.0/21" # East-2 CIDR's
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accepter.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.us_east1_hub.propagation_default_route_table_id
  
  depends_on = [ time_sleep.wait_for_network_mesh ]
}

output "aws_ec2_tgw_route_table_id" {
  value = aws_ec2_transit_gateway.us_east1_hub.propagation_default_route_table_id
}
