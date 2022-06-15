resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol = "email" # required email to send notification on
  endpoint = var.reciever_email

}

# need to check if sns topic is already created, if yes then will use that or else here we are creating new sns topic.
