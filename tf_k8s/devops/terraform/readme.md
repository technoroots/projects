# 1. Terraform

Terraform code directory to deploy infrastructure as a code maintained in this directory.

# 2. Structure & Guidelines
```
.
├── dev 
│   ├── global 
│   └── resources 
│       └── usw2 
│           ├── eks 
│           │   ├── cluster.tf 
│           │   ├── remote.tf 
│           │   └── variables.tf 
│           └── vpc 
│               ├── main.tf 
│               ├── output.tf 
│               ├── remote.tf
│               ├── variables.tf
│               └── vpcs.tf 
└── module_terraform 
    ├── eks_cluster 
    │   ├── allow_nodes.tf 
    │   ├── aws.tf 
    │   ├── eks-cluster.tf 
    │   ├── iam.tf 
    │   ├── kubeconfig.tf 
    │   ├── outputs.tf 
    │   ├── sg.tf 
    │   ├── variable.tf 
    │   └── worker_nodes.tf 
    └── vpc_default 
        └── main.tf
```
- Infrastructure is based on the environment and further dividing based on aws regions.
- `dev/global` directory contains services which are global to AWS like IAM, S3, etc.
- `dev/global/resources` directory contains region based services like EC2, EKS, etc.
- `module_terraform/` directory contains reusable modules from which you can import them in your terraform code

# 3. Maintainer

- @mankuuuuu  - <myan2007@gmail.com>


# 4. Table of contents
- [1. Terraform](#1-Terraform)
- [2. Structure & Guidelines](#2-Guide)
- [3. Maintainer](#3-Maintainer)
- [4. Table of contents](#4-Table-of-contents)
- [5. Prerequisites](#5-prerequisites)
- [6. Deploy](#6-deploy)

#5. Prerequisites

Packages required:
1. aws-iam-authenticator
2. jq
3. Terraform v0.12.19


Setup AWS credentials:
1. Generate your AWS access keys from the console based on the environment if you have multiple AWS account
2. export them
```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
```
3. LockFile table must be created in RDS for state locking
4. S3 Bucket must be created before running terraform plan

#6. Deploy

Deploy VPC

```bash
# Clone this repository
$ git clone https://github.com/

# Go into the repository
$ cd /travis/devops/terraform/vpc

# Initialize terraform
$ terraform init

# Edit variables.tf and remote.tf with your favourite editor and edit the VPC configuration values

# Check and plan the output
$ terraform plan -out=plan.out

# Apply the changes
$ terraform apply plan.out
```

Deploy EKS

```bash
# Clone this repository
$ git clone https://github.com/

# Go into the repository
$ cd /travis/devops/terraform/eks

# Initialize terraform
$ terraform init

# Edit remote.tf and variables.tf to set your cluster configuration

# Check and plan the output
$ terraform plan -out=plan.out

# Apply the changes
$ terraform apply plan.out
```
