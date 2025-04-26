terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.5.3"
    }
  }
}
