terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_image" "node" {
  name         = "node:18-alpine"
  keep_locally = false
}

resource "docker_image" "postgres" {
  name         = "postgres:13-alpine"
  keep_locally = false
}