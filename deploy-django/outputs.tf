
# Output the ELB DNS name
output "elb_dns_name" {
  value = module.api_alb.lb_dns_name
}


