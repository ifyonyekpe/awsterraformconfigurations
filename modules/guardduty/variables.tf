variable "enable_guardduty" {
  default = true
  type = bool
}

variable "enable_guardduty_s3_logs" {
  default = true
  type = bool
}

variable "enable_guardduty_kubernetes_audit_logs" {
  default = false
  type = bool
}

variable "enable_guardduty_ebs_volumes" {
  default = true
  type = bool
}