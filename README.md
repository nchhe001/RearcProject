
# Project Title

A Quest in the Clouds using Terraform and AWS 
## Approach
This project was created with Terraform and AWS.I have uploaded all the .tf  files and dockerfile to my Git repo

* Terraform
    * Backend.tf configured on S3 bucket 
    * Providers.tf configured for AWS
    * Variables.tf configured to pass variables on Terraform files
    * Network.tf holds the network build information
    * Loadbalancer.tf hosts the ALB build information 
    * Loadbalancersg.tf hosts all the network security group for load balancer and EC2

* Dockerfile
    * Dockerfile created with requested parameters


## Footnote
Due to time constraint, there are components that could probably have been done better. The objective was to complete the tasks with the awareness it was not a production environment.

* Public github repo was used, thus tokenization and authentication were disregarded.
* My personal laptop was used for deployment and EC2 keys were generated and stored locally and then attached during the deployment. AWS Key Management Service or any password vault integration was not included.
* Dockerhub or ECR was not used as dockerfile was composed and uploaded to the git repo. This file was used from github to build the image and run the containers during the EC2 instance build.
* No software provisioning, configuration management or automation tool such as Ansible were used as terraform (user_data) is capable of handling simpler scripts for this project. Provisioners would have been used for a complex setup.