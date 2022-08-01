# Main definition
data "digitalocean_vpc" "selected" {
  name = var.vpc_name
}

data "digitalocean_project" "p" {
  name = var.project_name
}
data "digitalocean_image" "ubuntu" {
  slug = "ubuntu-20-04-x64"
}

data "vault_generic_secret" "join_token" {
  path = "digitalocean/tokens"
}

data "http" "ssh_key" {
  url = var.ssh_public_key_url
}

resource "digitalocean_ssh_key" "consul" {
  name       = "Consul servers ssh key"
  public_key = data.http.ssh_key.response_body
  lifecycle {
    precondition {
      condition     = contains([201, 200, 204], data.http.ssh_key.status_code)
      error_message = "Status code is not OK"
    }
  }
}

resource "random_id" "key" {
  # keepers = {
  #   droplet = digitalocean_droplet.server[0].id
  # }
  byte_length = 32
}

resource "digitalocean_droplet" "server" {
  count         = var.servers
  image         = data.digitalocean_image.ubuntu.slug
  name          = "consul-${count.index}"
  region        = data.digitalocean_vpc.selected.region
  size          = var.droplet_size
  vpc_uuid      = data.digitalocean_vpc.selected.id
  ipv6          = false
  backups       = false
  monitoring    = true
  tags          = ["consul-server", "auto-destroy"]
  ssh_keys      = [digitalocean_ssh_key.consul.id]
  droplet_agent = true
  user_data = templatefile(
    "${path.module}/templates/userdata.tftpl",
    {
      consul_version = "1.12.3"
      username       = var.username
      datacenter     = var.datacenter
      servers        = var.servers
      ssh_pub_key    = data.http.ssh_key.body
      tag            = "consul-server"
      region         = data.digitalocean_vpc.selected.region
      join_token     = data.vault_generic_secret.join_token.data["autojoin_token"]
      encrypt        = random_id.key.b64_std
    }
  )

  # provisioner "local-exec" {
  #   command = "jq --arg value $(consul keygen) '.encrypt=$value' template.json > encrypt.json"
  # }
  # provisioner "file" {
  #   connection {
  #     type = "ssh"
  #     user = "root"
  #     host = self.ipv4_address
  #   }
  #   source      = "encrypt.json"
  #   destination = "/etc/consul.d/encrypt.json"
  # }
}

resource "digitalocean_firewall" "consul" {
  name        = "consul"
  droplet_ids = digitalocean_droplet.server[*].id

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "1-65535"
    source_load_balancer_uids = [digitalocean_loadbalancer.external.id]
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "1-65535"
    source_tags = ["consul-server"]
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "1-65535"
    source_tags = ["consul-server"]

  }
}

resource "digitalocean_project_resources" "consul_droplets" {
  project   = data.digitalocean_project.p.id
  resources = digitalocean_droplet.server[*].urn
}

resource "digitalocean_project_resources" "network" {

  project = data.digitalocean_project.p.id

  resources = [
    digitalocean_loadbalancer.external.urn,
    # digitalocean_domain.cluster.urn
  ]
}

resource "digitalocean_firewall" "ssh" {
  name        = "ssh"
  droplet_ids = digitalocean_droplet.server[*].id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_inbound_source_cidrs
  }

  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    #tfsec:ignore:digitalocean-compute-no-public-egress
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "digitalocean_loadbalancer" "external" {
  name     = "consul-external"
  region   = data.digitalocean_vpc.selected.region
  vpc_uuid = data.digitalocean_vpc.selected.id
  forwarding_rule {
    entry_port  = 80
    target_port = 8500
    #tfsec:ignore:digitalocean-compute-enforce-https
    entry_protocol  = "http"
    target_protocol = "http"
  }


  # forwarding_rule {
  #   entry_port       = 443
  #   target_port      = 8500
  #   entry_protocol   = "https"
  #   target_protocol  = "http"
  #   certificate_name = digitalocean_certificate.cert.name
  # }

  healthcheck {
    # https://www.consulproject.io/api-docs/system/health
    protocol               = "http"
    port                   = 8500
    path                   = "/v1/health/checks/consul"
    check_interval_seconds = 10
    healthy_threshold      = 3
  }

  droplet_ids = digitalocean_droplet.server[*].id
  # redirect_http_to_https = true
}
