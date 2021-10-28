#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "EC2-key" {
  provider   = aws.region
  key_name   = "Ec2key"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create EC2 in us-east-1
resource "aws_instance" "EC2instance" {
  provider                    = aws.region
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.EC2-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.EC2instance-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  user_data = <<-EOF
    #!/bin/bash
    #Download required git,docker and nvm components
    sudo su
    cd /home
    mkdir git
    cd git
    #Install Git
    sudo yum update -y
    sudo yum install git -y
    # Install docker
    sudo yum install docker -y
    sudo systemctl start docker
    # Initialize git
    git init
    git clone https://github.com/rearc/quest.git
    git clone https://github.com/nchhe001/Personal.git
    sudo cp /home/git/Personal/dockerfile.dockerfile /home/git/quest/dockerfile
    #Install nvm,npm
    cd quest
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    . ~/.nvm/nvm.sh
    nvm install node
    Npm install
    # Build Docker images and run container
    docker build . -t rearc
    docker run -p 3000:3000 -d rearc
   
  EOF

  tags = {
    Name = "EC2instance"
  }
  depends_on = [aws_main_route_table_association.set-EC2-default-rt-assoc]
}

