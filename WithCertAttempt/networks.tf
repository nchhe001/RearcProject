#Create VPC in us-east-1
resource "aws_vpc" "vpc" {
  provider             = aws.region
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "AngularApp"
  }

}

#Create internet gateway in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region
  vpc_id   = aws_vpc.vpc.id
}

#Create route table in us-east-1
resource "aws_route_table" "internet_route" {
  provider = aws.region
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
#Overwrite default route table of VPC   with our route table entries
resource "aws_main_route_table_association" "set-EC2-default-rt-assoc" {
  provider       = aws.region
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.internet_route.id
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region
  state    = "available"
}

#Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
}
#Create subnet #2  in us-east-1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
}


#Create association between route table and subnet_1 in us-east-1
resource "aws_route_table_association" "internet_association" {
  provider       = aws.region
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.internet_route.id
}


