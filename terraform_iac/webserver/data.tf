data "aws_subnet_ids" "webserver_subnets" {
  vpc_id = var.vpc_id
}
