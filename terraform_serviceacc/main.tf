terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.24.0"
    }
  }
}

provider "google" {
  project = "terraform-infralearns"
  region = "asia-south1"
  zone = "asia-south1-a"
  credentials = "terraform-infralearns-540465081d5b.json"
}

resource "google_compute_network" "custom_vpc_net" {
        name = "vpcnetlearncustomtf"
        auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_vpc_subnet" {
        name = "subvpcnetlearncustomtf"
        network = google_compute_network.custom_vpc_net.id
        ip_cidr_range = "22.0.0.0/24"
        region = "asia-south1"
}

resource "google_compute_subnetwork" "custom_vpc_subnet_sngpr" {
        name = "subvpcnetlearncustomtf"
        network = google_compute_network.custom_vpc_net.id
        ip_cidr_range = "22.1.0.0/24"
        region = "asia-southeast1"
}

resource "google_compute_firewall" "allow-icmp"{
    name = "allow-icmp"
    network = google_compute_network.custom_vpc_net.id
    allow{
        protocol = "icmp"
    }
    source_ranges =  ["157.46.133.123/32"]
}

output "customvpc"{
    value = google_compute_network.custom_vpc_net.id
}

resource "google_storage_bucket" "GCS_sh_acc_test1" {
    name = "tf_bucket_sh_acc_test"
    location = "ASIA"
    uniform_bucket_level_access = true
    //storage_class = "Multi-region"
    lifecycle_rule {
        condition {
          age = 1
        }
        action{
            type = "SetStorageClass"
            storage_class = "COLDLINE"
        }
    }
    retention_policy{
      is_locked = true
      retention_period = 864000
    }
}
