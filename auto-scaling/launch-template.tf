# Creating Public Secutiry Group for Public Web Servers

resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  referenced_security_group_id = var.alb_sg
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_1" {
  security_group_id = aws_security_group.public_sg.id
  referenced_security_group_id = var.alb_sg
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_2" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_3" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Creating launch template with auto-scaling group

resource "aws_launch_template" "asg_launch_template" {
  name_prefix   = "asg_launch_template"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data = base64encode(file("scripts/front-end-server.sh"))

    network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.public_sg.id]
  }
}


#--------------------------------------------------------------



# Creating Lambda_function to name ec2 instances upon lunch

# resource "aws_lambda_function" "name_instances" {
#   filename         = "lambda-function/lambda_function.py.zip"  # Ensure your Lambda code is zipped and accessible
#   function_name    = "name_instances"
#   role             = "arn:aws:iam::450665609241:role/lambda_exec_role"
#   handler          = "lambda_function.lambda_handler"
#   source_code_hash = filebase64sha256("lambda-function/lambda_function.py.zip")
#   runtime          = "python3.8"

#   environment {
#     variables = {
#       # Add environment variables if needed
#     }
#   }
# }

# resource "aws_cloudwatch_event_rule" "asg_instance_launch" {
#   name        = "asg_instance_launch"
#   event_pattern = jsonencode({
#     "source": [
#       "aws.autoscaling"
#     ],
#     "detail-type": [
#       "EC2 Instance-launch Lifecycle Action"
#     ],
#     "detail": {
#       "AutoScalingGroupName": [
#         "${aws_autoscaling_group.bar.name}"
#       ]
#     }
#   })
# }

# resource "aws_cloudwatch_event_target" "asg_instance_launch_target" {
#   rule      = aws_cloudwatch_event_rule.asg_instance_launch.name
#   target_id = "name_instances"
#   arn       = aws_lambda_function.name_instances.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.name_instances.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.asg_instance_launch.arn
# }

#----------------------------------------------------------------



# creating auto-scaling group

resource "aws_autoscaling_group" "bar" {
  # availability_zones = var.availability_zone
  desired_capacity   = 4
  max_size           = 6
  min_size           = 2
  vpc_zone_identifier = [var.public_subnet_1, var.public_subnet_2]

  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"

  }
  target_group_arns = var.alb_target_group_arns  # This artribute needs to be passed for targets to be registered in ALB

  tag {
    key                 = "Name"
    value               = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-Server"
    propagate_at_launch = true
  }
}

###########################################################################

# Creating Public Secutiry Group for Private Web Servers

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow SSH trafick on port 22"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_ssl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_from_alb" {
  security_group_id = aws_security_group.private_sg.id
  referenced_security_group_id = var.alb_private_sg
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
  

resource "aws_vpc_security_group_egress_rule" "outbound_traffic" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Creating launch template with auto-scaling group

resource "aws_launch_template" "asg_private_launch_template" {
  name_prefix   = "asg-private-launch-template"
  image_id      = var.image_id
  instance_type = var.instance_type

    network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.private_sg.id]
  }
}

#----------------------------------------------------------------

# creating Privat auto-scaling group

resource "aws_autoscaling_group" "private_asg" {
  # availability_zones = var.availability_zone
  desired_capacity   = 4
  max_size           = 6
  min_size           = 2
  vpc_zone_identifier = [var.private_subnet_1, var.private_subnet_2]

  launch_template {
    id      = aws_launch_template.asg_private_launch_template.id
    version = "$Latest"

  }
  target_group_arns = var.alb_private_target_group_arns  # This artribute needs to be passed for targets to be registered in ALB

  tag {
    key                 = "Name"
    value               = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-server"
    propagate_at_launch = true
  }
}


