provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "orbstack"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "orbstack"
  }
}

provider "argocd" {
  server_addr = "127.0.0.1:30443"
  username    = "admin"
  password    = data.kubernetes_secret.argocd_initial_admin_secret.data["password"]
  insecure    = true
}
