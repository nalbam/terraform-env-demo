# variable

variable "region" {
  description = "생성될 리전을 입력 합니다. e.g: ap-northeast-2"
  default     = "ap-northeast-2"
}

variable "cluster_name" {
  description = "EKS Cluster 이름을 입력합니다. e.g: eks-demo"
  default     = "eks-demo"
}

variable "cluster_role" {
  description = "EKS Cluster 롤을 입력합니다. e.g: dev, alpha, prod, devops"
  default     = "devops"
}

variable "root_domain" {
  default = ""
}

variable "base_domain" {
  default = ""
}

variable "acm_arn" {
  default = ""
}

variable "efs_id" {
  default = ""
}

### argo ###

variable "argo_enabled" {
  default = false
}

variable "argo_events_enabled" {
  default = false
}

variable "argo_cd_enabled" {
  default = false
}

variable "argo_cd_apps_enabled" {
  default = false
}

### monitor ###

variable "grafana_enabled" {
  default = false
}

variable "prometheus_enabled" {
  default = false
}

variable "datadog_enabled" {
  default = false
}

### logging ###

variable "fluentd_enabled" {
  default = false
}

### etc ###

variable "chaoskube_enabled" {
  default = false
}

variable "appmesh_enabled" {
  default = false
}

variable "weave_scope_enabled" {
  default = false
}

variable "cert_manager_enabled" {
  default = false
}

### atlantis ###

variable "atlantis_enabled" {
  default = true
}

### devops ###

variable "jenkins_enabled" {
  default = false
}

variable "chartmuseum_enabled" {
  default = false
}

variable "registry_enabled" {
  default = false
}

variable "harbor_enabled" {
  default = false
}

variable "archiva_enabled" {
  default = false
}

variable "nexus_enabled" {
  default = false
}

variable "sonarqube_enabled" {
  default = false
}

### gatekeeper ###

variable "kiali_gatekeeper" {
  default = false
}

variable "tracing_gatekeeper" {
  default = false
}

variable "weave_scope_gatekeeper" {
  default = false
}
