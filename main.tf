provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.16.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_az_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.16.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "public_az_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.16.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
}

resource "aws_subnet" "public_az_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.16.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"
}

resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
}

resource "aws_subnet" "private_app_az_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.4.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_app_az_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.5.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_app_az_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.6.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "private_db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.7.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.8.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_db_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.9.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pub_3" {
  subnet_id      = aws_subnet.public_az_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_2" {
  subnet_id      = aws_subnet.public_az_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_4" {
  subnet_id      = aws_subnet.public_az_3.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "priv_app_1" {
  subnet_id      = aws_subnet.private_app_az_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "priv_app_2" {
  subnet_id      = aws_subnet.private_app_az_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "priv_app_3" {
  subnet_id      = aws_subnet.private_app_az_3.id
  route_table_id = aws_route_table.private_rt.id
}
