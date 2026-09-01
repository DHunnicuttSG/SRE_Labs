output "public_ip" {

  value = aws_eip.lab.public_ip
}

output "instance_id" {

  value = aws_instance.lab.id
}

output "grafana_url" {

  value = "http://${aws_eip.lab.public_ip}:3000"
}

output "prometheus_url" {

  value = "http://${aws_eip.lab.public_ip}:9090"
}

output "loki_url" {

  value = "http://${aws_eip.lab.public_ip}:3100"
}