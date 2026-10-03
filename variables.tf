variable "region" {
  description = "AWS region to create the server in"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance size (t3.micro is free-tier eligible in most regions)"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "Path to the SSH public key that will be allowed to log in"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_allowed_cidr" {
  description = "IP range allowed to connect over SSH, e.g. 203.0.113.7/32 for one address"
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "ssh_allowed_cidr must be a valid CIDR block such as 203.0.113.7/32."
  }
}

variable "project" {
  description = "Name used to tag and name the resources"
  type        = string
  default     = "gdbook"
}
