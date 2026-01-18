resource "aws_ec2_transit_gateway" "us_east2_hub" {
  description = "US East2 Hub for VPC peering"
  provider = aws.east2
  
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "us-east2-hub-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_east2" {
  subnet_ids         = [aws_subnet.vpc1_east2_subnets[0].id, aws_subnet.vpc1_east2_subnets[1].id]
  transit_gateway_id = aws_ec2_transit_gateway.us_east2_hub.id
  vpc_id             = aws_vpc.vpc1_east2.id
  provider = aws.east2

  tags = {
    Name = "vpc1-east2-attachment"
  }

  depends_on = [ time_sleep.wait_for_tgw_attachment_east2 ]
}

resource "aws_ec2_transit_gateway_route" "to_vpc1_east1_tgw" {
  destination_cidr_block         = "10.1.0.0/21" # East-1 CIDR's
  provider = aws.east2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.us_east2_hub.propagation_default_route_table_id
  
  depends_on = [ time_sleep.wait_for_tgw_attachment_east1 ]
}

output "aws_ec2_east2_tgw_route_table_id" {
  value = aws_ec2_transit_gateway.us_east2_hub.propagation_default_route_table_id
}
