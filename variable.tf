variable "default_zone" {
  description = "The default zone when the services does not come with zone in metadata"
  type        = string
  default     = "nia.hashcorp"
}

variable "apikey" {
  description = "The api key used by NS1 provider"
  type        = string
}

variable "rate_limit_parallelism" {
  description = "The api rate limit"
  type        = number
  default     = 60
}

variable "endpoint" {
  description = "The NS1 endpoint used by NS1 Terraform provider. Managed DNS is the default value."
  type        = string
  default     = "https://api.nsone.net/v1/"
}

variable "services" {
  description = "Consul services monitored by Consul NIA"
  type = map(
    object({
      id        = string
      name      = string
      address   = string
      port      = number
      meta      = map(string)
      tags      = list(string)
      namespace = string
      status    = string

      node                  = string
      node_id               = string
      node_address          = string
      node_datacenter       = string
      node_tagged_addresses = map(string)
      node_meta             = map(string)
    })
  )
}