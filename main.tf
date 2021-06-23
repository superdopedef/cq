module "aws_utilities" {
  source = "./terraform/modules/aws/util"
}

module "aws_key_pair" {
  source = "./terraform/modules/aws/key"
  key_name = "${module.aws_utilities.random_name}-key"
}

module "aws_iam" {
  source = "./terraform/modules/aws/iam"
  name_prefix = module.aws_utilities.random_name
}

module "aws_vpc" {
  source = "./terraform/modules/aws/vpc"
  name_prefix = module.aws_utilities.random_name
  vpc_cidr = var.aws_vpc_cidr
  aws_tags = var.aws_tags
}

module "master" {
  source = "./terraform/modules/aws/host"
  instance_count = var.master_count
  instance_name = "master"
  instance_flavour = var.instance_flavour
  ami_id = module.aws_utilities.latest_debian_ami
  key_name =  module.aws_key_pair.key_name
  public_key = module.aws_key_pair.public_key
  iam_instance_profile = module.aws_iam.master
  subnet_ids = module.aws_vpc.master_subnet_ids
  security_group_ids = module.aws_vpc.master_sgs
  groups = "cq_master"
  name_prefix = module.aws_utilities.random_name
  aws_tags = merge( var.aws_tags, {"kubernetes.io/cluster/${module.aws_utilities.random_name}": "owned" })
}

module "aws_nlb" {
  source = "./terraform/modules/aws/nlb"
  vpc_id = module.aws_vpc.id
  subnet_ids = module.aws_vpc.master_subnet_ids
  instance_ids = module.master.ids
  name_prefix = module.aws_utilities.random_name
  aws_tags = merge( var.aws_tags, {"kubernetes.io/cluster/${module.aws_utilities.random_name}": "owned" })
}

module "worker" {
  source = "./terraform/modules/aws/host"
  instance_count = var.worker_count
  instance_name = "worker"
  instance_flavour = var.instance_flavour
  ami_id = module.aws_utilities.latest_debian_ami
  key_name =  module.aws_key_pair.key_name
  public_key = module.aws_key_pair.public_key
  iam_instance_profile = module.aws_iam.worker
  subnet_ids = module.aws_vpc.worker_subnet_ids
  security_group_ids = module.aws_vpc.worker_sgs
  groups = "cq_worker"
  name_prefix = module.aws_utilities.random_name
  aws_tags = merge( var.aws_tags, {"kubernetes.io/cluster/${module.aws_utilities.random_name}": "owned" })
}

resource "local_file" "kubeadm" {
    content     = templatefile("${path.module}/terraform/templates/kubeadm.config.tpl",{
      "master-lb" = module.aws_nlb.dns_name,
      "cluster" = module.aws_utilities.random_name
    })
    filename = "${path.module}/outputs/kubeadm-config.yml"
}

resource "local_file" "details" {
    content  = jsonencode(concat(module.master.details, module.worker.details))
    filename = "${path.module}/outputs/site.json"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/terraform/templates/ansible-inventory.tpl",
    {
      master-lb = module.aws_nlb.dns_name
      cluster = module.aws_utilities.random_name
      masters = module.master.public_ips
      workers = module.worker.public_ips
      domain_name = var.aws_domain_name
    }
  )
  filename = "${path.module}/outputs/inventory"
}