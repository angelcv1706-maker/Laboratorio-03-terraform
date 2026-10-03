resource "docker_network" "dev_net" {
  name = "dev-network"
}

resource "docker_container" "web_dev" {
  name  = "web-dev"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = 4001
  }
  volumes {
    host_path      = "${abspath(path.module)}/html/index.html"
    container_path = "/usr/share/nginx/html/index.html"
  }
  networks_advanced { name = docker_network.dev_net.name }
}

resource "docker_container" "api_dev" {
  name    = "api-dev"
  image   = docker_image.node.image_id
  command = ["node", "/app/index.js"]
  ports {
    internal = 3000
    external = 4002
  }
  volumes {
    host_path      = "${abspath(path.module)}/api/index.js"
    container_path = "/app/index.js"
  }
  networks_advanced { name = docker_network.dev_net.name }
}

resource "docker_container" "bd_dev" {
  name  = "bd-dev"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=root", "POSTGRES_USER=root", "POSTGRES_DB=devdb"]
  ports {
    internal = 5432
    external = 4003
  }
  networks_advanced { name = docker_network.dev_net.name }
}