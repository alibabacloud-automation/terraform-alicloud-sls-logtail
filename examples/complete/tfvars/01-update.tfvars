// instances variables
instance_password          = "YourPassword123!update"
internet_max_bandwidth_out = 20
tags = {
  Name = "update-tf-sls-logtail"
}

// log machine group variables
log_machine_topic = "update-tf-log-machine-topic"

// logtail config variables

config_input_detail = <<EOF
{
	"plugin": {
		"inputs": [{
			"detail": {
				"ExcludeEnv": null,
				"ExcludeLabel": null,
				"IncludeEnv": null,
				"IncludeLabel": null,
				"Stderr": true,
				"Stdout": true
			},
			"type": "service_docker_stdout"
		}]
	}
}
                EOF
config_input_type   = "plugin"
config_log_sample   = "update-test"