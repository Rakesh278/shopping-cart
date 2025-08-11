output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
  description = "Public IP of the Jenkins EC2 instance"
}