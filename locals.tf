locals {
  project_tags = {
    contact      = "devops@jjtechinc.com"
    application  = "static"
    project      = "jupiter"
    environment  = "${terraform.workspace}" # refers to your current workspace (dev, prod, etc)
    creationTime = timestamp()
  }
}