output "aws_region" {
  value = data.aws_region.current.region
}

output "aws_account" {
  value = data.aws_caller_identity.current.id
}
