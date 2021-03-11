NS1 Consul-Terraform-Sync Module
==================

> This project is in [beta](https://github.com/ns1/community/blob/master/project_status/WORK_IN_PROGRESS.md).

- NS1 Website: https://www.ns1.com
- Terraform Website: https://www.terraform.io

<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="600px">

------

This terraform module leverages consul-terraform-sync to create, delete and update DNS records and zones on NS1 managed DNS and Enterprise DDI based on registered services on Consul.

Please find more information about setting up your environment with **Consul Network Infrastructure Automation (NIA)** within its [Documentation Page](https://www.consul.io/docs/nia/tasks).


## Contents

1. [Requirements](#requirements)
2. [Notes](#notes)
3. [Config](#config)


## Requirements

-	[Terraform](https://www.terraform.io/downloads.html) 0.13
-	[Consul](https://www.consul.io/docs/install) 1.9.4
- [Consul-Terraform-Sync](https://www.consul.io/docs/nia) 0.1.0-beta
- [NS1 Terraform Provider](https://github.com/ns1-terraform/terraform-provider-ns1) 1.9.3

## Notes

The DNS zones and records are created based on the registered services on Consul.

The information used by the module are: meta.zone, meta.hostname and address.

The default zone value is in variable.tf and the default hostname is the service id on consul.

#### Here an example of service data with the required fields.

``` json
{
  "Name": "web",
  "Address": "192.168.1.10",
  "Meta": {
    "hostname": "ns1",
    "zone": "niaintegration.com"
  }
}
``` 

## Config

### consul-terraform-sync

``` terraform
## Global Config
log_level = "DEBUG"
port = 8558
syslog {}

buffer_period {
  enabled = true
  min = "5s"
  max = "20s"
}

# Consul Block
consul {
  address = "127.0.0.1:8500"
}

# Driver "terraform" block
driver "terraform" {
  log = false
  persist_log = false
  working_dir = ""
}

# Task Block
task {
 name           = "ns1-task"
 description    = "Create/delete/update DNS zones and records"
 source         = "github.com/ns1-terraform/terraform-ns1-record-sync-nia"
 services       = ["web", "api"]
 variable_files = ["/variable/file/with/api/key/terraform.tfvars"]
}
```
