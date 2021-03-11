terraform {
  required_providers {
    ns1 = {
      source = "ns1-terraform/ns1"
    }
  }
  required_version = ">= 0.13"
} 

provider "ns1" {
   apikey = var.apikey
   rate_limit_parallelism = var.rate_limit_parallelism
}

resource "ns1_zone" "nia_zones" {
 for_each = local.zones

 zone = each.value
}

resource "ns1_record" "nia_records_A" {
  for_each = local.services

  zone = ns1_zone.nia_zones[tostring(each.value.zone)].zone
  domain = each.value.hostname
  type = "A"
  answers {
    answer = each.value.address
  }
}

resource "local_file" "all_services" {
  content = join("\n", local.services_file)
  filename = "services.txt"
}

resource "local_file" "all_zones" {
  content = join("\n", local.zones_file)
  filename = "zone.txt"
}

locals {
  zones = toset([for id, s in var.services :
    lookup(s.meta, "zone", var.default_zone)
  ])

  zones_file = [for zone in local.zones :
    "${zone}"
  ]

  services = {for id, s in var.services :
    id => {zone = lookup(s.meta, "zone", var.default_zone), hostname = lookup(s.meta, "hostname", id), address = s.address}
  }

  services_file = [for id, s in local.services :
    "${id}:${s.zone}:${s.hostname}:${s.address}"
  ]
}