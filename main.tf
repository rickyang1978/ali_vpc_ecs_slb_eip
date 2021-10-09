//setup of providers
terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.138.0"
    }
  }
}

//setup of alicloud account
provider "alicloud" {
  access_key = "${var.my_access_key}"
  secret_key = "${var.my_secret_key}"
  region = "${var.my_region}"
}


data "alicloud_zones" "abc_zones" {}

//setup of default ECS instance type
data "alicloud_instance_types" "mem4core2" {
    memory_size = 4
    cpu_core_count = 2
    availability_zone = "${data.alicloud_zones.abc_zones.zones.0.id}"
}

//setup of VPC
resource "alicloud_vpc" "test_vpc" {
  vpc_name = "${var.my_vpc}"
  cidr_block = "${var.my_vpc_cidr_block}"
}

//setup of vswitch within the VPC
resource "alicloud_vswitch" "test_vswitch" {
    vswitch_name = "${var.my_vswitch}"
    vpc_id = "${alicloud_vpc.test_vpc.id}"
    cidr_block = "${var.my_vswitch_cidr_block}"
    zone_id = "${data.alicloud_zones.abc_zones.zones.0.id}"
}

//setup of Security Group within the VPC
resource "alicloud_security_group" "test_security_group" {
    name = "${var.my_security_group_name}"
    vpc_id = "${alicloud_vpc.test_vpc.id}"
}

//setup of Security Group rule allowing ingress http 80 traffic
resource "alicloud_security_group_rule" "http_in" {
    type = "ingress"
    ip_protocol = "tcp"
    policy = "accept"
    port_range = "80/80"
    security_group_id = "${alicloud_security_group.test_security_group.id}"
    cidr_ip = "0.0.0.0/0"
}

//setup of Security Group rule allowing ingress ssh 22 traffic
resource "alicloud_security_group_rule" "ssh_in" {
    type = "ingress"
    ip_protocol = "tcp"
    policy = "accept"
    port_range = "22/22"
    security_group_id = "${alicloud_security_group.test_security_group.id}"
    cidr_ip = "0.0.0.0/0"
}

//setup of N * ECS Instance with postpaid and private IP only
resource "alicloud_instance" "test_ecs" {
    instance_name = "${var.my_ecs_name}-${format(var.my_count_format, count.index+1)}"
    image_id = "${var.my_image_id}"
    instance_type = "${data.alicloud_instance_types.mem4core2.instance_types.0.id}"
    count = "${var.my_count}"
    system_disk_category = "${var.my_system_disk_category}"
    system_disk_size = "${var.my_system_disk_size}"
    security_groups = ["${alicloud_security_group.test_security_group.id}"]
    vswitch_id = "${alicloud_vswitch.test_vswitch.id}"
    password = "${var.my_password}"
    instance_charge_type = "${var.my_instance_charge_type}"
    internet_charge_type = "${var.my_internet_charge_type}"
    internet_max_bandwidth_out = "${var.my_internet_max_bandwidth_out}"
    user_data = "${file("install_http_server.sh")}"
}

//setup of SLB with private IP
resource "alicloud_slb" "test_slb" {
  bandwidth = 1000
  load_balancer_name = "${var.my_slb_name}"
  load_balancer_spec = "${var.my_slb_spec}"
  internet_charge_type = "${var.my_slb_internet_charge_type}"
  address_type = "${var.my_slb_address_type}"
  master_zone_id = "${data.alicloud_zones.abc_zones.zones.0.id}"
  vswitch_id = "${alicloud_vswitch.test_vswitch.id}"
}

//setup of SLB listener
resource "alicloud_slb_listener" "test_listener" {
  load_balancer_id = "${alicloud_slb.test_slb.id}"
  backend_port     = 80
  frontend_port    = 80
  protocol         = "tcp"
  bandwidth        = 1000
}

//setup of SLB backend servers 
resource "alicloud_slb_attachment" "default" {
  load_balancer_id = "${alicloud_slb.test_slb.id}"
  instance_ids     = "${alicloud_instance.test_ecs.*.id}"
}

//setup of EIP
resource "alicloud_eip_address" "test_eip" {
  address_name = "${var.my_eip_name}"
  internet_charge_type = "${var.my_eip_nternet_charge_type}"
  isp = "${var.my_isp}"
}

//attach EIP to SLB 
resource "alicloud_eip_association" "test_eip_association" {
  allocation_id = "${alicloud_eip_address.test_eip.id}"
  instance_id = "${alicloud_slb.test_slb.id}"
}