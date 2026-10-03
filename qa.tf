resource "docker_network" "qa_net" {
  name = "qa-network"
}

resource "docker_container" "web_qa" {
  name  = "web-qa"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = 5001
  }
  volumes {
    host_path      = "${abspath(path.module)}/html/index.html"
    container_path = "/usr/share/nginx/html/index.html"
  }
  networks_advanced { name = docker_network.qa_net.name }
}

resource "docker_container" "api_qa" {
  name    = "api-qa"
  image   = docker_image.node.image_id
  command = ["node", "/app/index.js"]
  ports {
    internal = 3000
    external = 5002
  }
  volumes {
    host_path      = "${abspath(path.module)}/api/index.js"
    container_path = "/app/index.js"
  }
  networks_advanced { name = docker_network.qa_net.name }
}

resource "docker_container" "bd_qa" {
  name  = "bd-qa"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=root", "POSTGRES_USER=root", "POSTGRES_DB=qadb"]
  ports {
    internal = 5432
    external = 5003
  }
  networks_advanced { name = docker_network.qa_net.name }
}