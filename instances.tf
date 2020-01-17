module "instances" {
  source                      = "alibaba/ecs-instance/alicloud"
  region                      = var.region
  version                     = ">=2.3.0"
  number_of_instances         = var.create_instance ? var.number_of_instance : 0
  image_id                    = var.image_id
  instance_type               = var.instance_type
  use_num_suffix              = true
  security_group_ids          = var.security_groups
  vswitch_id                  = var.vswitch_id
  user_data                   = local.user_data
  password                    = var.instance_password
  associate_public_ip_address = var.associate_public_ip_address
  internet_max_bandwidth_out  = var.internet_max_bandwidth_out
  tags = {
    Create = "terraform-alicloud-modules/sls-logtail/alicloud"
  }
}

data "alicloud_instances" "this" {
  ids = length(var.existing_instance_ids) == 0 ? null : var.existing_instance_ids
}