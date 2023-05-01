resource "null_resource" "update_aws_auth" {
  # Trigger used to save mapRoles updates on .tfstate
  triggers = {
    mapRoles = jsonencode(var.mapRoles)
  }

  # Call to .sh
  provisioner "local-exec" {
    command = "bash ${path.module}/update_configmap_tf.sh '${jsonencode(var.mapRoles)}' '${path.module}'"
  }
}

