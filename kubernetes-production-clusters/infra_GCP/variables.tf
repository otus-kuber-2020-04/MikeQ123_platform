variable "hosts" {
  type    = map  
  default = {  
    master1 = "master"
    master2 = "master"
    master3 = "master"
    worker1 = "worker"
    worker2 = "worker"
    #worker3 = "worker"
  }
}

variable "project_name" {
  type        = string
  description = "The name of the project to instanciate the instance at."
  default     = "otus-kuber-course"
}

variable "region_name" {
  type        = string
  description = "The region that this terraform configuration will instanciate at."
  default     = "us-east1"
}

variable "zone_name" {
  type        = string
  description = "The zone that this terraform configuration will instanciate at."
  default     = "us-east1-b"
}

variable "machine_type" {
  type        = string
  description = "The size that this instance will be."
  default     = "e2-medium"
}

variable "instance_name" {
  type = string
  description = "Instance name"
  default = "instance"
}

variable "image_name" {
  type        = string
  description = "The kind of VM this instance will become"
  default     = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190403"
}

variable "setup_kub_cluster_script_template" {
  type        = string
  description = "Script template to deploy kubecluster using kubespray"
  default     = "setup_kub_cluster.tmpl"
}

variable "setup_kub_cluster_script" {
  type        = string
  description = "Script to deploy kubecluster using kubespray"
  default     = "setup_kub_cluster.sh"
}

variable "ssh_key" {
  type        = string
  description = "SSH public key"
  default     = "key"
}

variable "private_key_path" {
  type        = string
  description = "SSH privete key path"
  default     = "~/.ssh/id_rsa"
}

variable "username" {
  type        = string
  description = "The name of the user that will be used to remote exec the script"
  default     = "root"
}

variable "inventory_filename" {
  type    = string  
  default = "inventory.yaml"
}

variable "inventory_template_filename" {
  type    = string
  default = "inventory.tmpl"
}

variable ansible_options {
  type    = string
  default = "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o userknownhostsfile=/dev/null' ansible_ssh_pipelining=true"
}
