data "aws_caller_identity" "default" {}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  # count               = var.monitor_free_storage_space_too_low ? 1 : 0
  alarm_name          = "OpenSearch Domain cu-operations alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_free_storage_space_too_low_periods #?
  # datapoints_to_alarm = var.alarm_free_storage_space_too_low_periods #?-
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = var.alarm_free_storage_space_too_low_period #?`
  statistic           = "Minimum"
  threshold           = var.FreeStorageSpaceThreshold #? %
  alarm_description   = "Free Storage Space minimum is <= 255 of the storage space for each node for 1 minute, 1 consecutive time"
  alarm_actions       = [aws_sns_topic.topic.arn] # fetch data 
  ok_actions          = [aws_sns_topic.topic.arn]
  # treat_missing_data  = "ignore" #?-

  dimensions = {
    DomainName = var.domain_name
	ClientId   = data.aws_caller_identity.default.account_id
  }
}

