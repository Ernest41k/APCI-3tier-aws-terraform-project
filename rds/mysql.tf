resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-subnet-group"
  subnet_ids = [var.private_subnet_3, var.private_subnet_4]

      tags = merge(var.tags,{
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-subnet-group"
  })
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  description = "Allow db traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "DB port"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block] # cidr block of VPC
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"  # allows any type of protocol
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    tags = merge(var.tags,{
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rds-sg"
  })
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  db_name              = "bremer"
  engine               = "mysql"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az = true
  publicly_accessible  = false
  storage_type         = "gp2"
#   backup_retention_period = 0
#   backup_window = "00:00-00:10" # window for frequent backups set to every 10 minutes
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # rds security group ID
  
#   # Specify an S3 bucket for backups
#   s3_import {
#     bucket_name = "mysql-automated-backup"
#     source_engine = "mysql"
#     source_engine_version = "8.0"
#     ingestion_role = aws_iam_role.s3RDS_backup.arn
#   }

#   iam_database_authentication_enabled = true
  


   tags = merge(var.tags,{
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bremer"
  })
}

# # Create IAM Role for RDS backup to s3
# resource "aws_iam_role" "s3RDS_backup" {
#   name = "s3RDS-backup"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "rds.amazonaws.com",
#         },
#       },
#     ],
#   })
# }

# resource "aws_iam_role_policy_attachment" "s3RDS_backup_policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
#   role       = aws_iam_role.s3RDS_backup.name
# }

# resource "aws_iam_role_policy" "s3RDS_backup_s3_policy" {
#   name   = "s3RDSBackupS3Policy"
#   role   = aws_iam_role.s3RDS_backup.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "s3:ListBucket",
#           "s3:GetObject",
#           "s3:PutObject",
#         ],
#         Effect   = "Allow",
#         Resource = [
#           "arn:aws:s3:::mysql-automated-backup",
#           "arn:aws:s3:::mysql-automated-backup/*",
#         ],
#       },
#     ],
#   })
# }

# # Add trust relationship to RDS role
# resource "aws_iam_role_policy" "s3RDS_backup_trust_policy" {
#   name = "s3RDSBackupTrustPolicy"
#   role = aws_iam_role.s3RDS_backup.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#       },
#     ],
#   })
# }