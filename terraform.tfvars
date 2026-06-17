cluster_name = "test-eks"
vpc_id       = "vpc-0a9acb9263bd5b3d0"
subnet_ids   = ["subnet-0950c5490920792c1", "subnet-05ee296eda30ce33c", "subnet-0ba551e5dcd24fa42"]
tags = {
  Environment = "dev"
  Terraform   = "true"
}
role_name            = "eks-role"
namespace            = "external-secrets"
service_account_name = "external-secrets-sa"
