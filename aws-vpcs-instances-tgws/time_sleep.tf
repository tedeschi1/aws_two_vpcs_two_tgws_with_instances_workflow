# resource "time_sleep" "wait_for_tgw_attachment_east1" {
#   depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc1_east1]

resource "time_sleep" "wait_for_network_mesh" {
  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accepter,
    aws_ec2_transit_gateway_vpc_attachment.vpc1_east1,
    aws_ec2_transit_gateway_vpc_attachment.vpc1_east2
  ]

  create_duration = "45s"
}