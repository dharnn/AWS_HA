output "HaiLoadBalancerDNS" {
    value = {
        "Blue" = module.hai_blue.alb_dns_name
        "Green" = module.hai_green.alb_dns_name
    }
}