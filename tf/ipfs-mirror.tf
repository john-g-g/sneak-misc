variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "ipfs-ubuntu-mirror" {
    image = "ubuntu-18-04-x64"
    name = "ipfs-ubuntu-mirror"
    region = "nyc1"
    size = "s-6vcpu-16gb"
    ipv6 = true
    monitoring = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    connection {
      user = "root"
      type = "ssh"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "while PID=$(pidof -s apt-get); do tail --pid=$PID -f /dev/null; done",
            "cat /etc/apt/sources.list",
            "add-apt-repository universe",
            "add-apt-repository multiverse",
            "export PATH=$PATH:/usr/bin:/usr/local/bin",
            "export GOPATH=$HOME/go",
            "export DEBIAN_FRONTEND=noninteractive",
            "apt update && apt install -y golang docker.io",
            "go get -d github.com/ipfs/ipget",
            "cd $HOME/go/src/github.com/ipfs/ipget",
            "make install",
            "docker run -p 4001:4001 -p 4002:4002/udp -p 5001:5001 -p 8080:8080 -p 8081:8081 -v /var/lib/ubuntumirror:/var/lib/ubuntumirror -v /var/lib/ipfs:/var/lib/ipfs -d sneak/ipfs-ubuntu-mirror"
        ]
    }
}
