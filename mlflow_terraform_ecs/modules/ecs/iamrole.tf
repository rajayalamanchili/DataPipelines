data "aws_iam_policy" "cloud_watch" {
  name = "AWSOpsWorksCloudWatchLogs"
}

data "aws_iam_policy" "ecs_task_execution" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_ssm" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter*",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:*:*:*"
      },
    ]
  })
}
resource "aws_iam_role" "ecs_task" {
  name = "${var.app_name}-${var.env}-ecs-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })

}

resource "aws_iam_role" "ecs_execution" {
  name = "${var.app_name}-${var.env}-ecs-execution"

  managed_policy_arns = [
    data.aws_iam_policy.cloud_watch.arn,
    data.aws_iam_policy.ecs_task_execution.arn,
    aws_iam_policy.ecs_ssm.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })

}