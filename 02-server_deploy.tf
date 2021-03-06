resource "upcloud_server" "poste" {
  hostname = "poste"
  count = 1
  zone = "us-nyc1"
  plan = "1xCPU-1GB"

  storage_devices {
    size = 25
    storage = "Ubuntu Server 20.04 LTS (Focal Fossa)"
    tier   = "maxiops"
    action = "clone"
  }

  network_interface {
    type = "public"
  }

  network_interface {
    type = "utility"
  }

  login {
    user = "USUARIO"
    keys = [
      "SSH_PUBLIC_KEY"
    ]
    create_password = false
  }

  connection {
    host        = self.network_interface[0].ip_address
    type        = "ssh"
    user        = "USUARIO"
    private_key = file("SSH_PRIVATE_KEY")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io docker-compose",
      "sudo usermod -aG docker $USER"
    ]
  }
}
