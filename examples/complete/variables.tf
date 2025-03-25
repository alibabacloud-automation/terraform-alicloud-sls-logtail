# instances variables
variable "instance_password" {
  description = "Password to an instance is a string of 8 to 30 characters. It must contain uppercase/lowercase letters and numerals, but cannot contain special symbols. When it is changed, the instance will reboot to make the change take effect."
  type        = string
  default     = "YourPassword123!"
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outgoing bandwidth to the public network, measured in Mbps (Mega bit per second). Value range:  [0, 100]."
  type        = number
  default     = 10
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {
    Name = "tf-sls-logtail"
  }
}

# log machine group variables
variable "log_machine_topic" {
  description = "The topic of a machine group."
  type        = string
  default     = "tf-log-machine-topic"
}

# logtail config variables
variable "config_input_detail" {
  description = "The logtail configure the required JSON files, this parameter is required if you will use this module to create logtail config. ([Refer to details](https://www.alibabacloud.com/help/doc-detail/29058.htm))"
  type        = string
  default     = <<EOF
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
}

variable "config_input_type" {
  description = "The input type. Currently only two types are supported: `file` and `plugin`."
  type        = string
  default     = "file"
}

variable "config_output_type" {
  description = "The output type. Currently, only LogService is supported."
  type        = string
  default     = "LogService"
}

variable "config_log_sample" {
  description = "The log sample of the Logtail configuration. The log size cannot exceed 1,000 bytes."
  type        = string
  default     = "test"
}