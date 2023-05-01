readme.so logo

dark
Download
SeçõesReset

Delete
Clique em uma seção abaixo para editar os conteúdos




Clique em uma seção abaixo para adicioná-la ao seu readme

Seção customizada

Referência

Documentação da API

Apêndice

Etiquetas

Documentação de cores

Contribuindo

Demonstração

Deploy

Documentação

Variáveis de Ambiente

Funcionalidades

Feedback

Perfil do GitHub - Sobre mim

Perfil do GitHub - Introdução

Perfil do GitHub - Links

Perfil do GitHub - Outros

Perfil do GitHub - Habilidades

Instalação

Aprendizados

Licença

Logo

Melhorias

Relacionados

Roadmap

Rodando localmente

Screenshots

Suporte

Stack utilizada

Rodando os testes

Usado por
Editor

## Authors and Contributors

- [@cayohollanda](https://www.github.com/cayohollanda)


Pré-visualização
Código fonte


# eks-aws-auth
This is a Terraform Module that updates the aws-auth configmap that are created in the EKS creation workflow.



## How Use

To use the module you just need to add in your .tf file the module declaration with the required variables like:

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

In your variables.tf you just need to add these variables:
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

And declare the variables in your terraform.tfvars like this:
```terraform
# terraform.tfvars
mapRoles                   = []
k8s_endpoint               = "YOUR-CLUSTER-ENDPOINT"
k8s_cluster_ca_certificate = "YOUR-CLUSTER-CA-CERTIFICATE"
k8s_token                  = "YOUR-CLUSTER-TOKEN"
```

Please, pay attention on mapRoles filling, you NEED to add the nodes role (default role of aws-auth) and then, you can add other object with your custom role
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

I suggest you to fill the module variables in the EKS creation moment and re-use the Kubernetes output variables like this:
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

Example of how can you get the k8s_token:
```terraform
# data.tf
data "aws_eks_cluster_auth" "this" {
  name = module.eks_cluster.eks_cluster_name
}
```
## FAQ

### How can I contribute with this module?

You can just create a fork and then, create a Pull Request to main repository.

### Can I relates a bug?

Yes! I appreciate you if you can do this and alert me. I will solve it as soon as possible. 

## Authors and Contributors

- [@cayohollanda](https://www.github.com/cayohollanda)


readme.so
