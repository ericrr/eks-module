# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


variable "subnets" {
  type        = list(string)
  default     = []
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)."  
}

variable "vpc_id" {
  type      = string
  default   = "vpc-00518c2a9a260c7aa"
  description = "VPC ID"
}

variable "ami" {
  type = string
  description = "ami eks" 
}

variable "cluster_name" {
  type = map(any)
  description = "cluster name"
}

variable "lbcontroller" {
  type = map(any)
  default = {}
  description = "Input values lb controller"
}

variable "nginx" {
  type = map(string)
  description = "Input values nginx ingress controller"
}

variable "nginx_configs" {
  type = map(string)
  description = "Dynamic values nginx ingress controller"
  default = {}
}

variable "prometheus" {
  type = map(string)
  description = "Enable and Input values prometheus"
}

variable "grafana" {
  type = map(string)
  description = "Enable and Input values grafana"
}

