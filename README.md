# terraform-digitalocean-consul

# 🚀 Consul cluster on digitalocean 🚀

https://github.com/coding-to-music/terraform-digitalocean-consul

From / By https://github.com/brucellino/terraform-digitalocean-consul

## Digitalocean Droplet Prices

https://github.com/andrewsomething/do-api-slugs

https://slugs.do-api.dev

```
# https://slugs.do-api.dev/

# s-1vcpu-512mb-10gb  $4    10GB
# s-1vcpu-1gb         $6    25GB
# s-1vcpu-2gb         $12   50GB
# s-2vcpu-2gb         $18   60GB
# s-2vcpu-4gb         $24   80GB
# s-4vcpu-8gb         $48   160GB
```

## Environment variables:

```java

```

## user interfaces:

## GitHub

```java
git init
git add .
git remote remove origin
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:coding-to-music/terraform-digitalocean-consul.git
git push -u origin main
```

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit) [![pre-commit.ci status](https://results.pre-commit.ci/badge/github/brucellino/terraform-digitalocean-consul/main.svg)](https://results.pre-commit.ci/latest/github/brucellino/terraform-digitalocean-consul/main) [![semantic-release: conventional](https://img.shields.io/badge/semantic--release-conventional-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# Terraform Module for Consul on Digital Ocean

This module creates a Consul cluster with agents and servers on Digital Ocean, using a load balancer as frontend.

It requires a Vault instance with Digital Ocean tokens in a KV store, and creates an ssh key by adding a GitHub user's public key.

## Examples

The `examples/` directory contains the example usage of this module.
These examples show how to use the module in your project, and are also use for testing in CI/CD.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                              | Version |
| --------------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)          | >1.2.0  |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement_digitalocean) | 2.21.0  |
| <a name="requirement_http"></a> [http](#requirement_http)                         | 3.0.1   |
| <a name="requirement_random"></a> [random](#requirement_random)                   | 3.3.2   |
| <a name="requirement_vault"></a> [vault](#requirement_vault)                      | 3.8.0   |

## Providers

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="provider_digitalocean"></a> [digitalocean](#provider_digitalocean) | 2.21.0  |
| <a name="provider_http"></a> [http](#provider_http)                         | 3.0.1   |
| <a name="provider_random"></a> [random](#provider_random)                   | 3.3.2   |
| <a name="provider_vault"></a> [vault](#provider_vault)                      | 3.8.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                                                        | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [digitalocean_domain.cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/domain)                               | resource    |
| [digitalocean_droplet.agent](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/droplet)                               | resource    |
| [digitalocean_droplet.server](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/droplet)                              | resource    |
| [digitalocean_firewall.consul](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/firewall)                            | resource    |
| [digitalocean_firewall.ssh](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/firewall)                               | resource    |
| [digitalocean_loadbalancer.external](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/loadbalancer)                  | resource    |
| [digitalocean_project_resources.agent_droplets](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/project_resources)  | resource    |
| [digitalocean_project_resources.network](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/project_resources)         | resource    |
| [digitalocean_project_resources.server_droplets](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/project_resources) | resource    |
| [digitalocean_record.server](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/record)                                | resource    |
| [digitalocean_ssh_key.consul](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/ssh_key)                              | resource    |
| [digitalocean_volume.consul_data](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/resources/volume)                           | resource    |
| [random_id.key](https://registry.terraform.io/providers/hashicorp/random/3.3.2/docs/resources/id)                                                           | resource    |
| [digitalocean_image.ubuntu](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/data-sources/image)                               | data source |
| [digitalocean_project.p](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/data-sources/project)                                | data source |
| [digitalocean_vpc.selected](https://registry.terraform.io/providers/digitalocean/digitalocean/2.21.0/docs/data-sources/vpc)                                 | data source |
| [http_http.consul_health](https://registry.terraform.io/providers/hashicorp/http/3.0.1/docs/data-sources/http)                                              | data source |
| [http_http.ssh_key](https://registry.terraform.io/providers/hashicorp/http/3.0.1/docs/data-sources/http)                                                    | data source |
| [vault_generic_secret.join_token](https://registry.terraform.io/providers/hashicorp/vault/3.8.0/docs/data-sources/generic_secret)                           | data source |

## Inputs

| Name                                                                                                      | Description                                                       | Type        | Default                                | Required |
| --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | ----------- | -------------------------------------- | :------: |
| <a name="input_agents"></a> [agents](#input_agents)                                                       | number of agent instances                                         | `number`    | `7`                                    |    no    |
| <a name="input_consul_version"></a> [consul_version](#input_consul_version)                               | Version of Consul to deploy                                       | `string`    | `"1.12.3"`                             |    no    |
| <a name="input_datacenter"></a> [datacenter](#input_datacenter)                                           | Name of the Consul datacenter                                     | `string`    | `"HashiDO"`                            |    no    |
| <a name="input_droplet_size"></a> [droplet_size](#input_droplet_size)                                     | Size of the droplet for Vault instances                           | `string`    | `"s-1vcpu-1gb"`                        |    no    |
| <a name="input_project_name"></a> [project_name](#input_project_name)                                     | Name of the project in digitalocean                               | `string`    | `"hashi"`                              |    no    |
| <a name="input_servers"></a> [servers](#input_servers)                                                    | number of server instances                                        | `number`    | `3`                                    |    no    |
| <a name="input_ssh_inbound_source_cidrs"></a> [ssh_inbound_source_cidrs](#input_ssh_inbound_source_cidrs) | List of CIDRs from which we will allow ssh connections on port 22 | `list(any)` | `[]`                                   |    no    |
| <a name="input_ssh_public_key_url"></a> [ssh_public_key_url](#input_ssh_public_key_url)                   | URL of of the public ssh key to add to the droplet                | `string`    | `"https://github.com/brucellino.keys"` |    no    |
| <a name="input_username"></a> [username](#input_username)                                                 | Name of the non-root user to add                                  | `string`    | `"hashiuser"`                          |    no    |
| <a name="input_vpc_name"></a> [vpc_name](#input_vpc_name)                                                 | Name of the VPC we are deploying into                             | `string`    | `"hashi"`                              |    no    |

## Outputs

| Name                                                                                   | Description                                         |
| -------------------------------------------------------------------------------------- | --------------------------------------------------- |
| <a name="output_agent_public_ips"></a> [agent_public_ips](#output_agent_public_ips)    | List of public IPs for the Consul agents            |
| <a name="output_load_balancer_ip"></a> [load_balancer_ip](#output_load_balancer_ip)    | Public IP of the load balancer fronting the servers |
| <a name="output_server_public_ips"></a> [server_public_ips](#output_server_public_ips) | List of public IPs for the Consul servers           |

<!-- END_TF_DOCS -->

## Attempt to run

```
terraform plan
```

```
running terraform get update then plan
provider.vault.address
  URL of the root of the target Vault server.

  Enter a value: ^C

Interrupt received.
Please wait for Terraform to exit or data loss may occur.
Gracefully shutting down...

Stopping operation...
data.digitalocean_project.p: Reading...
data.digitalocean_image.ubuntu: Reading...
data.digitalocean_vpc.selected: Reading...
data.http.ssh_key: Reading...
╷
│ Warning: Deprecated attribute
│
│   on main.tf line 78, in resource "digitalocean_droplet" "server":
│   78:       ssh_pub_key    = data.http.ssh_key.body
│
│ The attribute "body" is deprecated. Refer to the provider documentation for details.
│
│ (and one more similar warning elsewhere)
╵
╷
│ Error: execution halted
```
