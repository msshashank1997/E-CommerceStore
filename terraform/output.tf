output "Public_IP" {
    value = aws_instance.ubuntu[*].public_ip
}