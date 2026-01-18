resource "time_sleep" "wait_for_tgw_attachment" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc1_east1, aws_ec2_transit_gateway_route.to_vpc1_east2_tgw, aws_ec2_transit_gateway_vpc_attachment.vpc1_east2, aws_ec2_transit_gateway_route.to_vpc1_east1_tgw]

  create_duration = "30s"
}