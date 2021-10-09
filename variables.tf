variable "my_count" {
  default = "3"
}

variable "my_count_format" {
  default = "%02d"
}

variable "my_access_key" {
    description = "RAM user access_key"
    sensitive = true
}

variable "my_secret_key" {
    description = "RAM user secret_key"
    sensitive = true
}

variable "my_region" {
    default = "cn-hongkong"
}

variable "my_vpc" {
    default = "test_vpc"
}

variable "my_vpc_cidr_block" {
    default = "192.168.0.0/16"
}

variable "my_vswitch" {
    default = "test_vswitch"
}

variable "my_vswitch_cidr_block" {
    default = "192.168.0.0/24"
}

variable "my_security_group_name" {
    default = "test_security_group"
}

variable "my_ecs_name" {
    default = "test_ecs"
}

variable "my_image_id" {
  default = "ubuntu_20_04_x64_20G_alibase_20210927.vhd"
}

variable "my_system_disk_category" {
  default = "cloud_efficiency"
}

variable "my_system_disk_size" {
  default = "60"
}

variable "my_password" {
    description = "ssh password"
}

variable "my_instance_charge_type" {
  default = "PostPaid"
}

variable "my_internet_charge_type" {
  default = "PayByTraffic"
}

variable "my_internet_max_bandwidth_out" {
  default = 0
}

variable "my_slb_internet_charge_type" {
  default = "paybytraffic"
}

variable "my_slb_name" {
  default = "slb_worder"
}
variable "my_slb_spec" {
  default = "slb.s1.small"
}
variable "my_slb_address_type" {
  default = "intranet"
}

variable "my_eip_name" {
  default = "test_eip"
}

variable "my_eip_nternet_charge_type" {
  default = "PayByTraffic"
}

variable "my_isp" {
  default = "BGP"
}