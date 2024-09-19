resource "null_resource" "install_layer_deps" {
  triggers = {
    layer_build = filemd5("${local.layers_path}/aws-sdk/nodejs/package.json")
  }

  provisioner "local-exec" {
    working_dir = "${local.layers_path}/aws-sdk/nodejs"
    command = "npm install --production"
  }
}

data "archive_file" "fiap_auth_layer" {
    output_path = "files/fiap-auth-layer.zip"
    type = "zip"
    source_dir = "${local.layers_path}/aws-sdk"

    depends_on = [ null_resource.install_layer_deps ]
}

resource "aws_lambda_layer_version" "auth_api" {
  layer_name = "fiap-auth-layer"
  description = "aws-sdk: ^2.1691.0"
  filename = data.archive_file.fiap_auth_layer.output_path
  source_code_hash = data.archive_file.fiap_auth_layer.output_base64sha256
  compatible_architectures = ["x86_64"]
  compatible_runtimes = ["nodejs20.x"]
}