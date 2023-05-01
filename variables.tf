variable "mapRoles" {
  description = "A map of roles"
  type = list(object({
    rolearn   = string
    username  = string
    groups    = list(string)
  }))
}

variable "k8s_endpoint" {
  description = "The Kubernetes cluster endpoint."
  type        = string
}

variable "k8s_cluster_ca_certificate" {
  description = "The cluster CA certificate for the Kubernetes cluster."
  type        = string
}

variable "k8s_token" {
  description = "The Kubernetes cluster authentication token."
  type        = string
}