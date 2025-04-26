resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "time_sleep" "wait_30_seconds_argocd" {
  depends_on = [kubernetes_namespace.argocd]

  destroy_duration = "30s"
}

resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = "argocd"
  lint      = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.26"

  depends_on = [time_sleep.wait_30_seconds_argocd]
  timeout    = 600

  values     = [file("argocd-values.yaml")]
}

data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [
    helm_release.argocd
  ]
}

resource "argocd_repository" "kube_demoapp" {
  repo     = "https://github.com/ggnanasekaran77/kube-demoapp.git"
  insecure = true
}

resource "helm_release" "argocd_apps" {
  name      = "argocd-apps"
  namespace = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.2"

  depends_on = [
    time_sleep.wait_30_seconds_argocd,
    helm_release.argocd
  ]

  values = [
    file("argocd-apps-values.yaml")
  ]
}
