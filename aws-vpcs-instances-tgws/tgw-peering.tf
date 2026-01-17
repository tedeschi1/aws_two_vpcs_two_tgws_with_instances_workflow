resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  peer_region             = "us-east-2"
  peer_transit_gateway_id = aws_ec2_transit_gateway.us_east2_hub.id
  transit_gateway_id      = aws_ec2_transit_gateway.us_east1_hub.id

  tags = {
    Name = "east1 to east 2 tgw peering"
  }

  depends_on = [aws_ec2_transit_gateway.us_east1_hub, aws_ec2_transit_gateway.us_east2_hub]
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering_accepter" {
  provider                      = aws.east2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id

  depends_on = [ aws_ec2_transit_gateway.us_east1_hub, aws_ec2_transit_gateway.us_east2_hub]
}
