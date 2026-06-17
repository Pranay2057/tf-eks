variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "test-eks"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster nodes will be located"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "role_name" {
  description = "IAM role name for the service account"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace of the service account"
  type        = string
  default     = "default"
}

variable "service_account_name" {
  description = "Kubernetes service account name"
  type        = string
}
