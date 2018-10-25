terraform {
  required_version = ">= 0.11.9"
}

provider "datadog" {
  api_key = "${var.api_key}"
  app_key = "${var.app_key}"
}

resource "datadog_monitor" "consul_leader" {
  name    = "Monitor Consul Leaders"
  type    = "metric alert"
  message = "Consul cluster leader changed"

  query = "max(last_5m):default(avg:consul.raft.state.leader{*}.as_rate(), 0) > 0.2"

  thresholds {
    ok                = 0
    warning           = 0.1
    warning_recovery  = 0
    critical          = 0.2
    critical_recovery = 0
  }

  silenced {
    "*" = 0
  }

  notify_no_data    = false
  renotify_interval = 60
  notify_audit      = false
  timeout_h         = 60
  include_tags      = true
}

resource "datadog_monitor" "memory_monitor" {
  name    = "Percent System Mem Used - {{host.name}}"
  type    = "query alert"
  message = "System Mem Total \n\n- {{instance.name}}\n- {{host.env}}\n- {{host.instance-name}}\n- {{host.instancetype}}\n- {{host.name}}\n- {{host.ip}}"

  query = "avg(last_5m):( avg:system.mem.total{role:datadog} by {host,env} - ( avg:system.mem.free{role:datadog} by {host,env} + avg:system.mem.buffered{role:datadog} by {host,env} + avg:system.mem.cached{role:datadog} by {host,env} ) ) / avg:system.mem.total{role:datadog} by {host,env} * 100 \u003e 90"

  thresholds {
    ok       = 2
    warning  = 85.0
    critical = 90.0
  }

  include_tags        = true
  notify_no_data      = true
  no_data_timeframe   = "15"
  notify_audit        = false
  renotify_interval   = 0
  require_full_window = "true"
  timeout_h           = 0
  locked              = "true"
}

resource "datadog_monitor" "disk_monitor" {
  name    = "Disk usage has reached 95% on {{host.name}}"
  type    = "metric alert"
  message = "{{#is_alert}}\nProblem: Space is running out on device {{device.name}} on the host {{host.name}}, IP: {{host.ip}}.  Reclaim or add space on it. \n{{/is_alert}}"

  query = "max(last_10m):avg:system.disk.in_use{host:host.name} > 0.95"

  thresholds {
    critical = 0.95
    warning  = 0.9
  }

  timeout_h           = 1
  notify_no_data      = true
  no_data_timeframe   = 5
  notify_audit        = false
  require_full_window = true
  new_host_delay      = 300
  include_tags        = true
  locked              = false
  renotify_interval   = 240
}

resource "datadog_monitor" "cpu_monitor" {
  name           = "CPU usage high"
  query          = "avg(last_5m):${var.cpu_usage["query"]}{*} by ${var.trigger_by} > ${var.cpu_usage["threshold"]}"
  type           = "query alert"
  notify_no_data = true
  include_tags   = true

  message = ""
}

resource "datadog_timeboard" "host_metrics" {
  title       = "Host metrics"
  description = "Host level metrics: CPU, memory, disk, etc."
  read_only   = true

  graph {
    title     = "CPU usage"
    viz       = "timeseries"
    autoscale = true

    request {
      q          = "${var.cpu_usage["query"]}{*} by ${var.trigger_by}"
      aggregator = "avg"
      type       = "line"
    }

    marker {
      value = "y > ${var.cpu_usage["threshold"]}"
      type  = "error dashed"
    }
  }

  graph {
    title     = "Disk usage"
    viz       = "timeseries"
    autoscale = true

    request {
      q          = "${var.disk_usage["query"]}{*} by ${var.trigger_by}"
      aggregator = "avg"
      type       = "line"
    }

    marker {
      value = "y > ${var.disk_usage["threshold"]}"
      type  = "error dashed"
    }
  }
}

resource "datadog_downtime" "downtime_us" {
  active = "true"
  disabled = "false"
  scope = ["role:cs,env:prod"]
  message = "Enabling nginx monitors in US"
}




variable "trigger_by" {
  default = "{host,env}"
}

variable "datadog_alert_footer" {
  default = <<EOF
{{#is_no_data}}Not receiving data{{/is_no_data}}
{{#is_alert}}@pagerduty{{/is_alert}}
{{#is_recovery}}@pagerduty-resolve{{/is_recovery}}
@slack-alerts
EOF
}

variable "cpu_usage" {
  type = "map"

  default = {
    query     = "avg:aws.ec2.cpuutilization"
    threshold = "85"
  }
}

variable "disk_usage" {
  type = "map"

  default = {
    query     = "max:system.disk.in_use"
    threshold = "85"
  }
}
