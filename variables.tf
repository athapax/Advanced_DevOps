variable "domain_name" {
  description = "The domain name to use for the website"
  type        = string
  default     = "athapa.com"
}

variable "subdomain_name" {
  description = "The subdomain name to use for the website (e.g., www)"
  type        = string
  default     = "static"
}

variable "enable_waf" {
  description = "Whether to enable WAF on the CloudFront distribution"
  type        = bool
  default     = true
}

