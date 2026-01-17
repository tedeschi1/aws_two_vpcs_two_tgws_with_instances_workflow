data "aws_ami" "linux_ec2_east_2" {
  provider = aws.east2
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "east_2_ec2" {
  ami           = data.aws_ami.linux_ec2_east_2.id
  provider = aws.east2
  count = length(var.vpc1_east2_subnet_cidrs)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.vpc1_east2_subnets[count.index].id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.vpc1_east2_sg.id]
  key_name = "id_rsa"

  tags = {
    Name = "ec2-east2-${count.index + 1}"
    Environment = "Dev"
  }

  depends_on = [aws_subnet.vpc1_east2_subnets]
}
