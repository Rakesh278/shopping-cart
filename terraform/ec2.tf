data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
 subnet_id = module.vpc.public_subnets[0]
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "${var.project_name}-app-server"
  }
}
resource "aws_instance" "jenkins_server" {
 ami                    = data.aws_ami.amazon_linux.id  # ✅ Replace with a valid Amazon Linux 2 AMI
  instance_type = "t3.medium"
  key_name      = var.key_pair_name
  subnet_id = var.public_subnets[0] 
  associate_public_ip_address = true # ✅ First public subnet for Jenkins EC2

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y java-17-openjdk
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum install -y jenkins git docker
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo usermod -aG docker jenkins
    sudo systemctl restart docker
    sudo systemctl restart jenkins
  EOF

  tags = {
    Name = "${var.project_name}-jenkins-server"
  }
}
