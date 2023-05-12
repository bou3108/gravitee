project = "bbo-gravitee/mongodb"

labels = { "domaine" = "gravitee" }

runner {
    enabled = true
    data_source "git" {
        url  = "https://github.com/bou3108/gravitee.git"
        ref  = "main"
        path = "mongodb"
        ignore_changes_outside_path = true
    }
    poll {
        enabled = false
        interval = "24h"
    }
}

app "bbo-gravitee/mongodb" {

    build {
        use "docker-pull" {
            image = "mongo"
            tag   = "4.4"
            disable_entrypoint = true
        }
    }

    deploy {
        use "nomad-jobspec" {
            jobspec = templatefile("${path.app}/gravitee-mongodb.nomad.tpl", {
                datacenter = var.datacenter
				image = "mongo"
				tag   = "4.4"
            })
		}
	}
}

variable "datacenter" {
    type  = string
  default = "henix_docker_platform_integ"
}
