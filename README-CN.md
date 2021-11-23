Alibaba Cloud SLS Logtail Terraform Module   
terraform-alicloud-sls-logtail
=====================================================================

本 Module 用于在阿里云创建日志服务机器组及数据源ECS实例相关资源. 

本 Module 支持创建以下资源:

* [Log Machine Group](https://www.terraform.io/docs/providers/alicloud/r/log_machine_group.html)
* [Logtail Config](https://www.terraform.io/docs/providers/alicloud/r/logtail_config.html)
* [Logtail Attachment](https://www.terraform.io/docs/providers/alicloud/r/logtail_attachment.html)
* [ECS Instance](https://www.terraform.io/docs/providers/alicloud/r/instance.html)

## 用法

```hcl
module "logtail" {
  source = "terraform-alicloud-modules/sls-logtail/alicloud"
    
  #####################
  #创建SLS项目和logstore#
  #####################
  logstore_name      = "tf-sls-store"
  project_name       = "tf-sls-project"
    
  #############
  #创建机器组   #
  #############
  create_log_service        = true
  log_machine_group_name    = "log_machine_group_name"
  log_machine_identify_type = "ip"
  log_machine_topic         = "tf-module"
    
  ###############
  #创建log config#
  ###############
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
  #创建新的ECS实例#
  ##############
  create_instances   = true
  vswitch_id         = "vsw-xxxxxxxxx"
  number_of_instance = 1
  instance_type      = "ecs.g6.large"
  security_groups    = ["sg-xxxxxxxxxxxxx"]
  
  ######################################
  #通过指定已有实例的私网IP，将其加入到机器组中#
  ######################################
  existing_instance_private_ips = ["172.16.2.2", "172.16.2.3"]
}

```

## 示例

* [基本示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-sls-logtail/tree/master/examples/basic)

## 注意事项
本Module从版本v1.1.0开始已经移除掉如下的 provider 的显示设置：

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

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.0.0:

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

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显示定义一个系统过Region的provider：
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
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显示指定这个provider：

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

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)