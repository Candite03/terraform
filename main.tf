data "aws_ami" "CSG" {
  most_recent = true

  filter {
    name   = "name"
    values = ["csg-aws-alma-9*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

module "vpc" {
  source     = "./aws/network/vpc"
  
  vpc_name              = "vpc-CUSTOMER-tsuEKS-REGION-ENV-10.0.0.0/16"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_names   = ["sub-CUSTOMER-public-tsuEKS", "sub-CUSTOMER-public-tsuEKS"]
  public_subnet_cidrs   = ["10.0.0.0/24", "10.0.1.0/24"]
  subnet_azs            = ["eu-west-1a", "eu-west-1b"]
  private_subnet_names  = ["sub-CUSTOMER-app-tsuEKS", "sub-CUSTOMER-app-tsuEKS"]
  private_subnet_cidrs  = ["10.0.2.0/24", "10.0.3.0/24"]
  igw_name              = "igw-CUSTOMER-tsuEKS-REGION-ENV"
  ngw_name              = "ngw-CUSTOMER-tsuEKS-REGION-ENV"
  route_name            = "rtb-CUSTOMER-public-ENV"
  private_route_name    = "rtb-CUSTOMER-app-ENV"
  route_cidr            = "0.0.0.0/0"
  flow_log_name         = "fl-CUSTOMER-ENV-vpclogs"
  enable_internet_gw    = true
  create_public_subnet  = true
  create_private_subnet = false
  enable_nat_gateway    = false
}

module "ec2" {
  source     = "./aws/compute/ec2"
  instance_type = "t2.micro"
  ami_id        = data.aws_ami.CSG.id
  subnet_id     = [module.vpc.public_subnet_ids[0]]
}