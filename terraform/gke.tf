resource "google_service_account" "default" {
  account_id   = "defult-gke-sa"
  display_name = "Default Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = local.region

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = local.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    preemptible  = true

    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
