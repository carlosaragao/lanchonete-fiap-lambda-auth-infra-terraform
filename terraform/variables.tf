variable "AWS_REGION" {
  description = "AWS region"
  type        = string
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS Session Token"
  type        = string
}

# variable "cluster_name" {
#   description = "Name of the EKS cluster"
#   type        = string
# }

# variable "subnet_ids" {
#   description = "List of subnet IDs for the EKS cluster"
#   type        = list(string)

# }

# variable "max_size_capacity" {
#   description = "Max size number of nodes"
#   type        = number

# }

# variable "min_size_capacity" {
#   description = "Min size number of nodes"
#   type        = number

# }

# variable "desired_capacity" {
#   description = "Desired number of nodes"
#   type        = number
# }

# variable "node_instance_type" {
#   description = "Tipo de instância para os nodes do EKS"
#   type        = string
# }