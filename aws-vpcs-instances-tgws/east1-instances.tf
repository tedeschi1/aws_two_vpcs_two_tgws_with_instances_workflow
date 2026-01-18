data "aws_ami" "linux_ec2_east_1" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "east_1_ec2" {
  ami           = data.aws_ami.linux_ec2_east_1.id
  for_each      = toset(["web1", "web2", "web3"])
  instance_type = "t3.micro"
  #When using "for_each to create subnets you must specify single subnet ID like below"
  subnet_id     = aws_subnet.vpc1_east1_subnets["vpc1_subnet1"].id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.vpc1_east1_sg.id]
  key_name = "id_rsa"

  tags = {
    Name = each.key
    Environment = "Prod"
  }

  depends_on = [aws_subnet.vpc1_east1_subnets]
}
