output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.itra_vpc.id
}

output "az1_public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.itra_public_subnet_az1.id
}

output "az2_public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.itra_public_subnet_az2.id
}

output "az1_private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.itra_private_subnet_az1.id
}

output "az2_private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.itra_private_subnet_az2.id
}
