provider "aws" {
  region = "eu-central-1"
}

# VPC, Subnet, and Security Group
resource "aws_vpc" "react_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "react_subnet" {
  vpc_id     = aws_vpc.react_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "react_sg" {
  name   = "ecs-security-group"
  vpc_id = aws_vpc.react_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "react_igw" {
  vpc_id = aws_vpc.react_vpc.id
}

resource "aws_route_table" "react_route_table" {
  vpc_id = aws_vpc.react_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.react_igw.id
  }
}

resource "aws_route_table_association" "react_rt_assoc" {
  subnet_id      = aws_subnet.react_subnet.id
  route_table_id = aws_route_table.react_route_table.id
}

resource "aws_ecs_task_definition" "react_app_autobuild" {
  family                   = "my_task_definition"
  execution_role_arn       = "arn:aws:iam::535002858476:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"

  container_definitions = jsonencode([
    {
      name             = "react-app-autobuild"
      image            = "jpg344/react-app-autobuild"
      cpu              = 0
      essential        = true
      portMappings     = [
        {
          name          = "react-app-autobuild-80-tcp"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"        = "/ecs/my_task_definition"
          "mode"                 = "non-blocking"
          "awslogs-create-group" = "true"
          "max-buffer-size"      = "25m"
          "awslogs-region"       = "eu-central-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my_cluster"
}

# ECS Service
resource "aws_ecs_service" "react_app_service" {
  name            = "react-app-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.react_app_autobuild.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.react_subnet.id]
    security_groups = [aws_security_group.react_sg.id]
    assign_public_ip = true
  }
}