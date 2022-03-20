## create VPC
module "vpc" {
  source       = "./modules/vpc/"
  project_id   = var.project
  network_name = var.vpc_network_name
}
#
## create subnet
module "network_subnet" {
  source              = "./modules/subnets/"
  depends_on          = [module.vpc]
  subnet_name         = var.subnetwork_name
  network-subnet-cidr = var.network-subnet-cidr
  vpc_network_name    = var.vpc_network_name
  vpc_region          = var.vpc_region
}

## create firewall rules
module "firewall-rules" {
  source           = "./modules/firewall-rules/"
  depends_on       = [module.vpc]
  project_id       = var.project
  vpc_network_name = var.vpc_network_name
}

## VM instance
#module "vm_instance_rhel_public1" {
#  source        = "./modules/vm-instance/"
#  depends_on    = [module.network_subnet]
#  vpc_name      = var.vpc_network_name
#  subnet_name   = var.subnetwork_name
#  subnet_zone   = var.vpc_zone
#  instance_name = "rhel-instance1"
#}

# module "vm_instance_rhel_public2" {
#   source        = "./modules/vm-instance/"
#   depends_on    = [module.network_subnet]
#   vpc_name      = var.vpc_network_name
#   subnet_name   = var.subnetwork_name
#   subnet_zone   = var.vpc_zone
#   instance_name = "rhel-instance2"
# }

module "instance_template" {
  source      = "./modules/instance_template"
  depends_on  = [module.network_subnet]
  project_id  = var.project
  name_prefix = "rhel-template"
  vpc_name    = var.vpc_network_name
  subnet_name = var.subnetwork_name
  subnet_zone = var.vpc_zone
}

module "mig1" {
  source            = "./modules/mig"
  project_id        = var.project
  region            = var.region
  target_size       = var.target_size
  hostname          = "nginx1"
  instance_template = module.instance_template.self_link
}

module "mig2" {
  source            = "./modules/mig"
  project_id        = var.project
  region            = var.region
  target_size       = var.target_size
  hostname          = "nginx2"
  instance_template = module.instance_template.self_link
}
module "gce-lb-http" {
  source      = "./modules/lb-http"
  depends_on  = [module.mig1, module.mig2]
  project     = var.project
  name        = "nginx-http-lb"
  target_tags = ["nginx_backend"]
  backend1    = module.mig1.instance_group
  backend2    = module.mig2.instance_group
}
