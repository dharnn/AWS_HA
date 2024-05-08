#Launch Template
resource "aws_launch_template" "my-app" {
    name = "${var.launch-temp}_${var.vpc_name}"
    image_id = data.aws_ami.web-aurora.id
    instance_type = var.chassis
    vpc_security_group_ids = [var.sg_id]
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "my-app_${var.vpc_name}"
      }
    }
    lifecycle {
      create_before_destroy = true
    }
}

#Create Autoscaling group
resource "aws_autoscaling_group" "asg" {
  launch_template {
    id = aws_launch_template.my-app.id
    version = "$latest"
  }
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = [ aws_lb_target_goup.asg-tg.arn ]
  health_check_type = "ELB"
  min_size = 2
  desired_capacity = 3
  max_size = 3
  tag {
    key = "Name"
    value = "asg"
    propagate_at_launch = true
  }
}

#Create Application LoadBalancer
resource "aws_lb" "loadbalancer" {
  name = "loadbalancer-${replace(var.vpc_name, "_", "-")}"
  load_balancer_type = "application"
  subnets = var.subnet_ids
  security_groups = [ var.sg_id ]
}

#Create Loadbalancer Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

#Create Target Group
resource "aws_lb_target_group" "asg-tg" {
  name = "asgtg-${replace(var.vpc_name, "_", "-")}"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

#Listener Rule
resource "aws_lb_listener_rule" "asg-listen" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100
    condition {
      path_pattern {
        values = [ "*" ]
      }
    }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg-tg.arn
  }
}
