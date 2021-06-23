resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge({ Name = "${var.name_prefix}-vpc" }, var.aws_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({ Name = "${var.name_prefix}-igw" }, var.aws_tags)
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "master" {
  count = min(length(data.aws_availability_zones.available.names), var.min_az_count, var.max_az_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  vpc_id            = aws_vpc.vpc.id
  tags = merge({ Name = "${var.name_prefix}-master-${data.aws_availability_zones.available.names[count.index]}" },
        { "kubernetes.io/cluster/${var.name_prefix}" = "owned" }, var.aws_tags)
}  

resource "aws_subnet" "worker" {
  count = min(length(data.aws_availability_zones.available.names), var.min_az_count, var.max_az_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 10 + count.index)
  vpc_id            = aws_vpc.vpc.id
  tags = merge({ Name = "${var.name_prefix}-worker-${data.aws_availability_zones.available.names[count.index]}" },
        { "kubernetes.io/cluster/${var.name_prefix}" = "owned" }, var.aws_tags)
}

resource "aws_route_table" "master-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge({ Name = "${var.name_prefix}-rt" }, { "kubernetes.io/cluster/${var.name_prefix}" = "owned" }, var.aws_tags)
}

resource "aws_route_table_association" "rta" {
  count = min(length(data.aws_availability_zones.available.names), var.min_az_count, var.max_az_count)
  subnet_id      = aws_subnet.master[count.index].id
  route_table_id = aws_route_table.master-rt.id
}

resource "aws_route_table_association" "rtb" {
  count = min(length(data.aws_availability_zones.available.names), var.min_az_count, var.max_az_count)
  subnet_id      = aws_subnet.worker[count.index].id
  route_table_id = aws_route_table.master-rt.id
}

resource "aws_security_group" "internal" {
  name        = "${var.name_prefix}-internal"
  description = "Internal cluster communications"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow ALL within this group"
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }
  tags = merge({ Name = "${var.name_prefix}-internal" }, var.aws_tags)
}

resource "aws_security_group" "master-allow-ingress" {
  name        = "${var.name_prefix}-master-ingress"
  description = "Allow K8s master ingress communications"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow K8S API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "${var.name_prefix}-master-ingress" }, var.aws_tags)
}
resource "aws_security_group" "worker-allow-ingress" {
  name        = "${var.name_prefix}-worker-ingress"
  description = "Allow K8s worker ingress communications"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "${var.name_prefix}-worker-ingress" }, { "kubernetes.io/cluster/${var.name_prefix}" = "owned" }, var.aws_tags)
}
