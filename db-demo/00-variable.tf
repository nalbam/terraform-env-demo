# variable

variable "region" {
  description = "생성될 리전을 입력 합니다. e.g: ap-northeast-2"
  default     = "ap-northeast-2"
}

variable "name" {
  description = "생성될 Database 이름을 입력합니다."
  default     = "db-demo"
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "11.8"
}

variable "db_instance_type" {
  description = "Instance type for database instance"
  type        = string
  default     = "db.t2.micro"
}

variable "db_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Name of database inside storage engine"
  type        = string
  default     = "postgres"
}

variable "db_username" {
  description = "Name of user inside storage engine"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password inside storage engine"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "Port on which database will accept connections"
  type        = number
  default     = 5432
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = true
}

# DB subnet group

# variable "db_subnet_ids" {
#   description = "A list of VPC subnet IDs"
#   type        = list(string)
#   default     = []
# }

# DB parameter group

variable "db_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "postgres11"
}

# DB option group

variable "db_major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "11"
}
