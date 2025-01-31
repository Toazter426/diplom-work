terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}


#VM
#VM-Web-1
resource "yandex_compute_instance" "web-1" {
  name        = "web-1"
  hostname    = "web-1"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.security-ssh-traffic.id, yandex_vpc_security_group.security-webservers.id]
    ip_address         = "10.0.1.5"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#remove-for-submission
  scheduling_policy {
    preemptible = true
  }
}

#VM-Web-2
resource "yandex_compute_instance" "web-2" {
  name        = "web-2"
  hostname    = "web-2"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-2.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.security-ssh-traffic.id, yandex_vpc_security_group.security-webservers.id]
    ip_address         = "10.0.2.5"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#remove-for-submission
  scheduling_policy {
    preemptible = true
  }
}

#VM-Bastion
resource "yandex_compute_instance" "bastion-host" {
  name        = "bastion-host"
  hostname    = "bastion-host"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-3.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security-bastion-host.id]
    ip_address         = "10.0.3.15"
  }#remove-for-submission

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#remove-for-submission
  scheduling_policy {
    preemptible = true
  }
}

#VM-Prometheus
resource "yandex_compute_instance" "prometheus" {
  name        = "prometheus"
  hostname    = "prometheus"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-3.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.security-ssh-traffic.id, yandex_vpc_security_group.security-prometheus.id]
    ip_address         = "10.0.3.5"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#remove-for-submission
  scheduling_policy {
    preemptible = true
  }
}

#VM-Grafana
resource "yandex_compute_instance" "grafana" {
  name        = "grafana"
  hostname    = "grafana"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-3.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security-public-grafana.id, yandex_vpc_security_group.security-ssh-traffic.id]
    ip_address         = "10.0.3.10"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#remove-for-submission
  scheduling_policy {
    preemptible = true
  }
}

#VM-Elastic
resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 4
    memory        = 8
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.security-elasticsearch.id, yandex_vpc_security_group.security-ssh-traffic.id]
    ip_address         = "10.0.1.7"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#remove-for-submission
  scheduling_policy {
    preemptible = true
  }
}

#VM-Kibana
resource "yandex_compute_instance" "kibana" {
  name     = "kibana"
  hostname = "kibana"
  zone     = "ru-central1-a"
  platform_id = "standard-v3"
  
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-3.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.security-public-kibana.id, yandex_vpc_security_group.security-ssh-traffic.id]
    ip_address         = "10.0.3.6"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
#remove-for-submission
  scheduling_policy {
    preemptible = true
  }
}
