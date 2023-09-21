variable "notification_name" {
  type    = string
  default = null
}

variable "sns_topic_arn" {
  type = string
}

variable "codebuild_project_arn" {
  type = string
}

variable "enable_codebuild_state_notifications" {
  type    = bool
  default = false
}

variable "enable_full_codebuild_state_detail" {
  type    = bool
  default = false
}

variable "enable_codebuild_phase_notifications" {
  type    = bool
  default = false
}

variable "enable_full_codebuild_phase_detail" {
  type    = bool
  default = false
}