output "slb_public_ip" {
  value = alicloud_eip_address.test_eip.ip_address
}

output "slb_backendserver" {
  value = "${alicloud_slb_attachment.default.backend_servers}"
}