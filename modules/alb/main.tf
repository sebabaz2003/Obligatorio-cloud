
# Balanceador de carga publico
resource "aws_lb" "app" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Grupo de servidores que recibiran las solicitudes
resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  # Mantener solicitudes del mismo cliente en una instancia
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 3600
    enabled         = true
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# Recibir solicitudes HTTP por el puerto 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}


# Alarma cuando hay menos de 2 servidores saludables
resource "aws_cloudwatch_metric_alarm" "healthy_hosts" {
  alarm_name        = "${aws_lb.app.name}-healthy-hosts"
  alarm_description = "Alerta cuando el ALB tiene menos de 2 servidores saludables"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "HealthyHostCount"
  comparison_operator = "LessThanThreshold"
  threshold           = 2

  statistic          = "Minimum"
  period             = 60
  evaluation_periods = 2
  treat_missing_data = "missing"

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
    TargetGroup  = aws_lb_target_group.app.arn_suffix
  }
}

