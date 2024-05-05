data "http" "myip" {
  count = var.allow_current_ip_public_access ? 1 : 0
  url = "https://ipv4.icanhazip.com"
}