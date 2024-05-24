data "aws_region" "current" {}

data "aws_secretsmanager_secret" "mlflow_artifact_bucket" {
  name = var.mlflow_s3_url_ssm_name
}

data "aws_secretsmanager_secret_version" "mlflow_artifact_bucket" {
  secret_id = data.aws_secretsmanager_secret.mlflow_artifact_bucket.id
}

data "aws_secretsmanager_secret" "mlflow_backend_db_url" {
  name = var.mlflow_db_url_ssm_name
}

data "aws_secretsmanager_secret_version" "mlflow_backend_db_url" {
  secret_id = data.aws_secretsmanager_secret.mlflow_backend_db_url.id
}

resource "aws_cloudwatch_log_group" "mlflow_log_grp" {
  name              = "/ecs/${var.app_name}/${var.env}"
  retention_in_days = var.log_rentention_days
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${var.env}"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family = "${var.app_name}-${var.env}"

  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_service_cpus
  memory                   = var.ecs_service_memory

  container_definitions = jsonencode([{
    name      = "mlflow"
    image     = var.mlflow_ecr_repo_url
    essential = true

    portMappings = [{ containerPort = var.mlflow_port }]
    # secrets = [
    #   {
    #     name      = "MLFLOW_ARTIFACT_BUCKET"
    #     valueFrom = data.aws_secretsmanager_secret_version.mlflow_artifact_bucket.secret_string
    #   },
    #   {
    #     name      = "MLFLOW_BACKEND_DB_URL"
    #     valueFrom = data.aws_secretsmanager_secret_version.mlflow_backend_db_url.secret_string
    #   }
    # ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.mlflow_log_grp.name
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

}

resource "aws_ecs_service" "ecs_service" {
  name             = "${var.app_name}-${var.env}"
  cluster          = aws_ecs_cluster.ecs_cluster.id
  task_definition  = aws_ecs_task_definition.ecs_task.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.vpc_public_subnet_ids
    security_groups  = [var.ecs_service_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.mlflow_lb_target_grp.arn
    container_name   = "mlflow"
    container_port   = 8080
  }

  depends_on = [aws_lb.mlflow_lb]
}
