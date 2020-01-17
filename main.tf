provider "alicloud" {
  version                 = ">=1.60.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/sls-logtail/alicloud"
}

resource "alicloud_log_machine_group" "this" {
  count         = var.create_log_service ? 1 : 0
  identify_list = compact(distinct(concat(module.instances.this_private_ip, local.existing_instance_ips)))
  name          = var.log_machine_group_name == "" ? local.log_machine_group_name : var.log_machine_group_name
  project       = var.project_name
  topic         = var.log_machine_topic
}

resource "alicloud_logtail_config" "this" {
  count        = var.create_log_service ? 1 : 0
  input_detail = var.config_input_detail
  input_type   = var.config_input_type
  logstore     = var.logstore_name
  name         = var.config_name == "" ? local.config_name : var.config_name
  output_type  = var.config_output_type
  project      = var.project_name
  log_sample   = var.config_log_sample
}

resource "alicloud_logtail_attachment" "this" {
  count               = var.create_log_service ? 1 : 0
  logtail_config_name = concat(alicloud_logtail_config.this.*.name, [""])[0]
  machine_group_name  = concat(alicloud_log_machine_group.this.*.name, [""])[0]
  project             = var.project_name
}

