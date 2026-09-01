# SRE_Labs

Lab Environment files

You MAY need to update a few items.  
* Change the region on line 3 of variables.tf if needed, default is us-east-1
* Change the key name on line 3 of terraform.tfvars to your key name.  ServerKey is default

Log into AWS cloudshell and upload all the files from the terraform directory.
- Use Actions / Upload Files  

Check if terraform is installed
```bash
terraform version
```

If not: then install using:
```bash
sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

sudo yum -y install terraform
```

Verify install
```bash
terraform version
```
Create an EC2 key pair if you do not have one and update terraform.tfvars file with the name.
```bash
aws ec2 create-key-pair \
--key-name ServerKey \
--query 'KeyMaterial' \
--output text > ServerKey.pem
```

Initialize terraform
```bash
terraform init
```

Validate terraform configuration
```bash
terraform validate
```

Plan
```bash
terraform plan
```

Deploy
```bash
terraform apply
```

* type yes to question at end of apply text

Terraform will begin building

After the build you can ssh into the ec2 instance.