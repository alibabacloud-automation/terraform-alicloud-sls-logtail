data "alicloud_zones" "default" {
}

data "alicloud_instance_types" "this" {
  cpu_core_count    = 2
  memory_size       = 4
  availability_zone = data.alicloud_zones.default.zones.0.id
}

data "alicloud_images" "ubuntu" {
  name_regex = "^ubuntu_18.*64"
}

# Create a new vpc used to create ecs instance
module "vpc" {
  source             = "alibaba/vpc/alicloud"
  create             = true
  vpc_cidr           = "172.16.0.0/16"
  vswitch_cidrs      = ["172.16.0.0/21"]
  availability_zones = [data.alicloud_zones.default.zones.0.id]
}

# Create a new security group used to create ecs instance
module "sg" {
  source              = "alibaba/security-group/alicloud"
  vpc_id              = module.vpc.this_vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
}

# Create log service by sls module
module "sls" {
  source = "terraform-alicloud-modules/sls/alicloud"
}

//ecs-instance
module "ecs" {
  source = "../.."

  //ecs-instance
  create_instance = true

  number_of_instance          = 1
  image_id                    = data.alicloud_images.ubuntu.ids.0
  instance_type               = data.alicloud_instance_types.this.ids.0
  use_num_suffix              = true
  security_groups             = [module.sg.this_security_group_id]
  vswitch_id                  = module.vpc.this_vswitch_ids[0]
  instance_password           = var.instance_password
  associate_public_ip_address = true
  internet_max_bandwidth_out  = var.internet_max_bandwidth_out
  tags                        = var.tags

  //sls-logtail
  create_log_service = false

}

//sls-logtail
module "logtail" {
  source = "../.."

  //ecs-instance
  create_instance = false

  //sls-logtail
  create_log_service = true

  //alicloud_log_machine_group
  existing_instance_private_ips = ["172.16.2.2", "172.16.2.3"]
  log_machine_group_name        = "tf-log-machine-group-name"
  project_name                  = module.sls.this_log_project_name
  log_machine_topic             = var.log_machine_topic

  //alicloud_logtail_config
  config_input_detail = var.config_input_detail
  config_input_type   = var.config_input_type
  logstore_name       = module.sls.this_log_store_name
  config_name         = "tf-logtail-config-name"
  config_output_type  = var.config_output_type
  config_log_sample   = var.config_log_sample

}