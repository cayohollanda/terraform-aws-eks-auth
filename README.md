
# eks-aws-auth
This Terraform Module updates the aws-auth configmap created during the EKS creation workflow.


## Prerequisites

Before using this module, ensure that you have met the following prerequisites:

1. Install [Terraform](https://www.terraform.io/downloads.html)
2. Configure your [AWS CLI](https://aws.amazon.com/cli/) with the appropriate AWS account credentials.
3. Have an existing EKS cluster or use a Terraform module to create one.


## How Use

To use this module, simply add the module declaration with the required variables to your .tf file:

```terraform
# main.tf
module "eks-auth" {
  source                     = "cayohollanda/eks-auth/aws"
  version                    = "0.0.1-alpha"

  k8s_endpoint               = var.k8s_endpoint
  k8s_cluster_ca_certificate = var.k8s_cluster_ca_certificate
  k8s_token                  = var.k8s_token
  mapRoles                   = var.mapRoles

}
```

In your variables.tf file, add the following variables:
```terraform
# variables.tf
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
```

Declare the variables in your terraform.tfvars file as follows:
```terraform
# terraform.tfvars
mapRoles                   = []
k8s_endpoint               = "YOUR-CLUSTER-ENDPOINT"
k8s_cluster_ca_certificate = "YOUR-CLUSTER-CA-CERTIFICATE"
k8s_token                  = "YOUR-CLUSTER-TOKEN"
```

Please pay attention to the mapRoles configuration. You NEED to add the nodes role (default role of aws-auth) and then you can add other objects with your custom roles:
```terraform
# terraform.tfvars
mapRoles = [
    {
      rolearn = "arn:aws:iam::[ACCOUNT-ID]:role/[NODES-ROLE-NAME]",
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn = "arn:aws:iam::[ACCOUNT-ID]:role/[ROLE-NAME]"
      username = "[USERNAME]"
      groups = ["[GROUPS]"]
    }
]
```

We suggest filling the module variables during EKS creation and reusing the Kubernetes output variables like this:
```terraform
# main.tf
module "eks-auth" {
  source                     = "cayohollanda/eks-auth/aws"
  version                    = "0.0.1-alpha"

  k8s_endpoint               = module.eks_cluster.endpoint
  k8s_cluster_ca_certificate = module.eks_cluster.certificate_authority.0.data
  k8s_token                  = data.aws_eks_cluster_auth.this.token # Get this information in datafile
  mapRoles                   = var.mapRoles

}
```

Here's an example of how to obtain the k8s_token:
```terraform
# data.tf
data "aws_eks_cluster_auth" "this" {
  name = module.eks_cluster.eks_cluster_name
}
```
## FAQ

### How can I contribute to this module?

Simply create a fork and then submit a Pull Request to the main repository.

### Can I report a bug?

Yes! We appreciate your help in identifying any issues. We will address them as soon as possible.

## License

[GPL-3.0](https://github.com/cayohollanda/terraform-aws-eks-auth/blob/main/LICENSE)


## Authors and Contributors

- [@cayohollanda](https://www.github.com/cayohollanda)


