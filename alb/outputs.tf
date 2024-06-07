output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "alb_private_sg" {
  value = aws_security_group.alb_private_sg.id
}

output "alb_target_group_arns" {
  value = [aws_lb_target_group.alb_target_group.arn]
}

output "alb_private_target_group_arns" {
  value = [aws_lb_target_group.alb_private_target_group.arn]
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

