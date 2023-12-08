terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.21.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "dos15-antonenko-s3"
    key            = "var/lib/jenkins/workspace/test-pipeline/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}


#vpc resource
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "DOS15-onl_Antonenko"
  }
}

#aws_subnets a-b-c
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public_b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "рublic_c"
  }
}

#aws internet gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "antonenko-igw"
  }
}

#aws route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

#association with route and subnets a-b-c
resource "aws_route_table_association" "а" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "Ь" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "с" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}

# aws security group
resource "aws_security_group" "my_sg" {
  name   = "DOS15-onl_Antonenko_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow http from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow http from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DOS15-onl_Antonenko_sg"
  }
}

#aws load balancer for group and subnets
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]
}

# creating aws listener for load balancer and switching with target group for redirecting traffic
resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

# target group for receiving traffic and redirecting to ec2 instances
resource "aws_lb_target_group" "my_tg" {
  name        = "my-tg"
  # target type can be lambda function or data base or something else
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
}

# aws required template for autoscaling group
resource "aws_launch_template" "my_launch_template" {
  name = "DOS15-onl_Antonenko_template"

  image_id      = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "DOS15-Antonenko-ec2"

  # user data script that starts only while starting ec2
  user_data = filebase64("${path.module}/server.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.my_sg.id]
  }
}

# aws autoscaling group
resource "aws_autoscaling_group" "my_asg" {
  name                = "DOS15-onl_Antonenko_asg"
  max_size            = 5
  min_size            = 2
  health_check_type   = "ELB" #optional
  desired_capacity    = 2
  target_group_arns   = [aws_lb_target_group.my_tg.arn]
  vpc_zone_identifier = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

# aws policy for scale up while CPU loading
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "DOS15-onl_Antonenko_scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
}

# aws cloudwatch metric alarm for scale up alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "DOS15-onl_Antonenko_scale_up_alarm"
  alarm_description   = "asg- scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "50"
  dimensions          = {
    "AutoScalingGroupName" = aws_autoscaling_group.my_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# policy for scale down while CPU offloading
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "DOS15-onl_Antonenko_scale_down"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# aws cloudwatch metric for scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "DOS15-onl_Antonenko_scale_down_alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions          = {
    "AutoScalingGroupName" = aws_autoscaling_group.my_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}

