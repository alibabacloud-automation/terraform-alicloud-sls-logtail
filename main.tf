# Create the ECS instances to install logtail
module "instances" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "2.12.0"

  number_of_instances         = var.create_instance ? var.number_of_instance : 0
  image_id                    = var.image_id
  instance_type               = var.instance_type
  use_num_suffix              = var.use_num_suffix
  security_group_ids          = var.security_groups
  vswitch_id                  = var.vswitch_id
  user_data                   = local.user_data
  password                    = var.instance_password
  associate_public_ip_address = var.associate_public_ip_address
  internet_max_bandwidth_out  = var.internet_max_bandwidth_out
  tags                        = var.tags
}

resource "alicloud_log_machine_group" "this" {
  count         = var.create_log_service ? 1 : 0
  identify_list = compact(distinct(concat(module.instances.this_private_ip, var.existing_instance_private_ips)))
  name          = var.log_machine_group_name == "" ? local.log_machine_group_name : var.log_machine_group_name
  project       = var.project_name
  topic         = var.log_machine_topic
  identify_type = var.log_machine_identify_type
}

resource "alicloud_logtail_config" "this" {
  count        = var.create_log_service ? 1 : 0
  project      = var.project_name
  input_detail = var.config_input_detail
  input_type   = var.config_input_type
  logstore     = var.logstore_name
  name         = var.config_name == "" ? local.config_name : var.config_name
  output_type  = var.config_output_type
  log_sample   = var.config_log_sample
}

resource "alicloud_logtail_attachment" "this" {
  count               = var.create_log_service ? 1 : 0
  project             = var.project_name
  logtail_config_name = concat(alicloud_logtail_config.this[*].name, [""])[0]
  machine_group_name  = concat(alicloud_log_machine_group.this[*].name, [""])[0]
}
