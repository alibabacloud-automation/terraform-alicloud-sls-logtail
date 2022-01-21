Alibaba Cloud SLS Logtail Terraform Module   
terraform-alicloud-sls-logtail

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-sls-logtail/blob/master/README-CN.md)

Terraform module which creates sls logtail resources on Alibaba Cloud.

These types of resources are supported:

* [Log Machine Group](https://www.terraform.io/docs/providers/alicloud/r/log_machine_group.html)
* [Logtail Config](https://www.terraform.io/docs/providers/alicloud/r/logtail_config.html)
* [Logtail Attachment](https://www.terraform.io/docs/providers/alicloud/r/logtail_attachment.html)
* [ECS Instance](https://www.terraform.io/docs/providers/alicloud/r/instance.html)

## Usage

```hcl
module "logtail" {
  source = "terraform-alicloud-modules/sls-logtail/alicloud"
    
  #####
  #SLS#
  #####
  create_log_service = true
  logstore_name      = "tf-sls-store"
  project_name       = "tf-sls-project"
    
  #############
  #log machine#
  #############
  create_log_service        = true
  log_machine_group_name    = "log_machine_group_name"
  log_machine_identify_type = "ip"
  log_machine_topic         = "tf-module"
    
  ############
  #log config#
  ############
  config_name               = "config_name"
  config_input_type         = "file"
  config_input_detail       = <<EOF
                              {
                                  "discardUnmatch": false,
                                  "enableRawLog": true,
                                  "fileEncoding": "gbk",
                                  "filePattern": "access.log",
                                  "logPath": "/logPath",
                                  "logType": "json_log",
                                  "maxDepth": 10,
                                  "topicFormat": "default"
                              }
                              EOF
    
  ##############
  #ecs instance#
  ##############
  create_instances   = true
  vswitch_id         = "vsw-xxxxxxxxx"
  number_of_instance = 1
  instance_type      = "ecs.g6.large"
  security_groups    = ["sg-xxxxxxxxxxxxx"]
  
  ################################################################
  #setting existing ecs instance private ip to join machine group#
  ################################################################
  existing_instance_private_ips = ["172.16.2.2", "172.16.2.3"]
}

```

## Examples

* [Basic example](https://github.com/terraform-alicloud-modules/terraform-alicloud-sls-logtail/tree/master/examples/complete)

## Notes
From the version v1.1.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  version                 = ">=1.60.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/sls-logtail/alicloud"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.0.0:

```hcl
module "logtail" {
  source        = "terraform-alicloud-modules/sls-logtail/alicloud"
  version       = "1.0.0"
  region        = "cn-shanghai"
  profile       = "Your-Profile-Name"
  logstore_name = "tf-sls-store"
  project_name  = "tf-sls-project"
  // ...
}
```

If you want to upgrade the module to 1.1.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
  region  = "cn-shanghai"
  profile = "Your-Profile-Name"
}
module "logtail" {
  source        = "terraform-alicloud-modules/sls-logtail/alicloud"
  logstore_name = "tf-sls-store"
  project_name  = "tf-sls-project"
  // ...
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-shanghai"
  profile = "Your-Profile-Name"
  alias   = "sh"
}
module "logtail" {
  source        = "terraform-alicloud-modules/sls-logtail/alicloud"
  providers     = {
    alicloud = alicloud.sh
  }
  logstore_name = "tf-sls-store"
  project_name  = "tf-sls-project"
  // ...
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.

More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.60.0 |

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)