resource "null_resource" "remote_exec" {
  connection {
      type = "ssh"
      host = var.ec2_public_ip_address
      user = var.ec2_user
      private_key = file(var.ec2_pem)
      agent = false 
  }
   
 provisioner "remote-exec" {
        inline = [
          "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
          "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
          "sudo apt-get update",
          "sudo apt-get install -y fontconfig openjdk-11-jre",
          "sudo apt-get install -y jenkins",
          "sudo systemctl start jenkins",
          "sudo systemctl enable jenkins"
        ]
    }   

resource "null_resource" "local_exec" {
  provisioner "local-exec" {
    command = <<-EOT
        "echo 'This is local-exec test case' > file.txt",
                ssh -i ${var.pem_path} ubuntu@${var.ec2_eip} 'sudo cat /var/Jenkins_home/secrets/initialAdminPassword' > admin_password
      EOT
  }
  depends_on = [
  null_resource.remote_exec
  ]
 }
}