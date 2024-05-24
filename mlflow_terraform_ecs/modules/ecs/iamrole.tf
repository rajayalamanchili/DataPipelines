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
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:*:*:*"
      },
    ]
  })
}

resource "aws_iam_policy" "s3_rds" {

  name = "${var.app_name}-${var.env}-s3-rds"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:List*"
        ],
        "Resource" : [
          "arn:aws:s3:::*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "rds-db:connect"
        ],
        "Resource" : [
          "arn:aws:rds:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.app_name}-${var.env}-ecs-task"

  managed_policy_arns = [
    aws_iam_policy.ecs_ssm.arn,
    aws_iam_policy.s3_rds.arn
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

resource "aws_iam_role" "ecs_execution" {
  name = "${var.app_name}-${var.env}-ecs-execution"

  managed_policy_arns = [
    data.aws_iam_policy.cloud_watch.arn,
    data.aws_iam_policy.ecs_task_execution.arn,
    aws_iam_policy.s3_rds.arn,
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