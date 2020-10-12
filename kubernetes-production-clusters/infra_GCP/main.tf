# This is the provider used to spin up the gcloud instance
provider "google-beta" {
  project = var.project_name
  region  = var.region_name
  zone    = var.zone_name
  access_token = data.google_client_config.default.access_token
}

# Locks the version of Terraform for this particular use case
terraform {
  required_version = "~>0.13.0"
}

# This creates the google instance
resource "google_compute_instance" "vm_instance" {
  provider = google-beta
  for_each = var.hosts

  name         = each.key
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }
  
  attached_disk {
    source                  = "${each.key}-data"
    device_name             = "data"
    mode                    = "READ_WRITE"
  }

  attached_disk {
    source                  = "${each.key}-docker"
    device_name             = "docker"
    mode                    = "READ_WRITE"
  }

  network_interface {
    network       = "default"
    # Associated our public IP address to this instance
    access_config {
      nat_ip = google_compute_address.static[each.key].address
    }
  }

  metadata = {
    ssh-keys = "${var.username}:${var.ssh_key}"
  }
}

resource "google_compute_disk" "data" {
  provider = google-beta
  for_each = var.hosts

  name  = "${each.key}-data"
  zone  = var.zone_name
  size  = 20
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}

resource "google_compute_disk" "docker" {
  provider = google-beta
  for_each = var.hosts

  name  = "${each.key}-docker"
  zone  = var.zone_name
  size  = 10
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  provider = google-beta
  for_each = var.hosts
  name = each.key
}

resource "google_compute_target_pool" "webapp" {
  provider = google-beta
  name = "instance-pool"

  instances = compact([ for host, role  in var.hosts: role == "worker" ? google_compute_instance.vm_instance[host].self_link : "" ])
  #health_checks = [
  #  google_compute_http_health_check.default.name,
  #]
}

resource "google_compute_forwarding_rule" "webapp" {
  provider = google-beta
  name       = "webapp-http-forwarding-rule"
  target     = google_compute_target_pool.webapp.id
  port_range= "80-443"
}

#resource "google_compute_http_health_check" "default" {
#  name               = "default"
#  request_path       = "/"
#  check_interval_sec = 1
#  timeout_sec        = 1
#}

resource "google_compute_firewall" "webapp" {
  provider = google-beta
  name    = "webapp-firewall"
  network = google_compute_forwarding_rule.webapp.network

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "6443"]
  }

  #source_tags = ["webapp"]
}

locals {
  #https://www.terraform.io/docs/configuration/expressions.html#for-expressions
  nodes_strings = [ for host, role  in var.hosts: "${host} ansible_host=${google_compute_address.static[host].address} ansible_user=${var.username} ${var.ansible_options} ip=${google_compute_instance.vm_instance[host].network_interface[0].network_ip} etcd_member_name=${host}"]
  master_strings = [ for host, role  in var.hosts: role == "master" ? host : "" ]
  worker_strings = [ for host, role  in var.hosts: role == "worker" ? host : "" ]
}

resource local_file "inventory" {
  filename = var.inventory_filename
  content  = templatefile (var.inventory_template_filename, { nodes_strings = local.nodes_strings, 
                                                    master_strings = local.master_strings,
                                                    worker_strings = local.worker_strings })
}

resource local_file "kub_script" {
  filename = var.setup_kub_cluster_script
  content  = templatefile (var.setup_kub_cluster_script_template, 
                           { inventory_filename = var.inventory_filename,
                           private_key_path = var.private_key_path })
}

resource "null_resource" "provision" {
  depends_on  =   [google_compute_instance.vm_instance]

  provisioner "local-exec" {
    command     = "sh ./${var.setup_kub_cluster_script}"
    working_dir = path.module
  }
}


data "google_client_config" "default" {
}
