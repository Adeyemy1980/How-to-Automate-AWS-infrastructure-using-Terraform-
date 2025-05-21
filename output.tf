output "dev_vpc" {
  value = aws_vpc.dev_vpc.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway.id
}

output "Subnet" {
  value = aws_subnet.Subnet.id
}

output "route_table" {
  value = aws_route_table.route_table.id
}

output "public_ip" {
    value = aws_instance.Nginx-web-server.public_ip
  
}
