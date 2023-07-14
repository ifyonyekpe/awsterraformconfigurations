variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "createdBy" {
  type        = string
  description = "User who created the resource"
}

variable "cidrBlock" {
  default = "10.0.0.0/16"
}

variable "dbSubnets" {
  type = list(any)
}

variable "privateSubnets" {
  type = list(any)
}

variable "publicSubnets" {
  type = list(any)
}


variable "dbEngine" {
  type        = string
  description = "DB Engine"
}

variable "dbEngineVersion" {
  type        = string
  description = "DB Engine Version"
}

variable "dbUsername" {
  type        = string
  description = "DB Username"
}

variable "dbPassword" {
  type        = string
  description = "DB Password"
  sensitive   = true
}

variable "dbName" {
  type        = string
  description = "DB Name"
}