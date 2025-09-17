################################################################################
# Supporting Resources
################################################################################

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = var.alb_sg_name
  vpc_id      = module.vpc.vpc_id
  description = var.alb_sg_description

  ingress_cidr_blocks = var.alb_sg_ingress_cidr_blocks
  tags                = var.alb_sg_tags
}

################################################################################
# Application load balancer (ALB)
################################################################################

module "alb" {
  # Change the source to the correct module
  source          = "terraform-aws-modules/aws/alb"
  version         = "~> 8.0"
  name            = var.alb_name
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_http_sg.security_group_id]

  # The rest of your code is now correct for this module
  listeners = {
    http_80 = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "default"
      }
    }
  }

  target_groups = {
    default = {
      name             = var.alb_target_group_name
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/phpinfo.php"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }
  tags = var.alb_tags
}
