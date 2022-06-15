variable "domain_name" {
   default = "haniqa"
}

variable "alarm_free_storage_space_too_low_periods" {
  default = 60
}

variable "alarm_free_storage_space_too_low_period" {
  default = 60
}

variable "FreeStorageSpaceThreshold" {
  default = "25" # % 25/100
}

# variable "aws_sns_topic_arn" {
# }


variable "sns_topic_name" {
  type = string
  default = "cloudwatch_topic_opensearch"
}

variable "reciever_email" {
  type = list(string)
  default = ["ikalkanci@collectors.com", "mchen@collectors.com"]
}
