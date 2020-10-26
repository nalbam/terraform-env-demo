# variable

variable "region" {
  description = "생성될 리전을 입력 합니다. e.g: ap-northeast-2"
  default     = "ap-northeast-2"
}

variable "name" {
  description = "생성될 EKS Cluster 이름을 입력합니다."
  default     = "eks-demo"
}

variable "kubernetes_version" {
  description = "쿠버네티스 버전을 입력합니다."
  default     = "1.18"
}

variable "cluster_log_types" {
  description = "CloudWatch 로그를 설정 합니다."
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  # api, audit, authenticator, controllerManager, scheduler
}

variable "cluster_log_retention_in_days" {
  description = "로그 저장 기간을 입력 합니다."
  default     = 7
}

variable "allow_ip_address" {
  description = "접속 허용 IP 목록을 입력 합니다."
  default = [
    "10.0.0.0/8",   # vpn
    "10.10.1.0/24", # bastion
    # "211.60.50.190/32", # echo "$(curl -sL icanhazip.com)/32"
  ]
}

variable "launch_configuration_enable" {
  description = "Launch Configuration 을 생성 할지 선택 합니다."
  default     = false
}

variable "launch_template_enable" {
  description = "Launch Template 을 생성 할지 선택 합니다."
  default     = true
}

variable "launch_each_subnet" {
  description = "모든 Subnet 에 생성 할지 선택 합니다."
  default     = false
}

variable "associate_public_ip_address" {
  description = "공개 IP 를 생성 할지 선택 합니다."
  default     = false
}

variable "instance_type" {
  description = "워커 노드 인스턴스 타입"
  default     = "m5.large"
}

variable "mixed_instances" {
  description = "워커 노드 추가 인스턴스 타입 목록"
  default     = ["c5.large", "r5.large"]
}

variable "volume_type" {
  description = "워커 노드 볼륨 타입"
  default     = "gp2"
}

variable "volume_size" {
  description = "워커 노드 볼륨 사이즈"
  default     = "32"
}

variable "min" {
  description = "워커 노드 오토스케일링그룹 최소값"
  default     = "1"
}

variable "max" {
  description = "워커 노드 오토스케일링그룹 최대값"
  default     = "5"
}

variable "on_demand_base" {
  description = "워커 노드 on_demand 기본 갯수"
  default     = "0"
}

variable "on_demand_rate" {
  description = "워커 노드 on_demand 유지 비율"
  default     = "0"
}

variable "irsa_enabled" {
  description = "Whether to create OpenID Connect Provider for EKS to enable IRSA"
  default     = true
}

variable "efs_enabled" {
  description = "EFS 스토리지 생성 여부를 선택 합니다."
  default     = true
}

variable "key_name" {
  description = "워커 노드 키페어 이름을 입력 합니다."
  default     = "bruce-seoul"
}

variable "key_path" {
  description = "워커 노드 키페어에 local file 을 사용한다면 경로를 입력 합니다."
  default     = ""
}

variable "domain_name" {
  default = "bruce.spic.me"
}
