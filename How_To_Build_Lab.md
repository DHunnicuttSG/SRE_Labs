# Instructions for building SRE Lab

### 1. Create an EC2 instance in AWS
* You will need to create and download a security key in AWS for your EC2 Instance.  You can use the same key for access to the lab.
* Verify/replace your key name (terraform.tfvars lin 3) and region (variables.tf line 3) 

### 2. Add admin ability to run terraform from EC2

Create IAM role
Go to AWS Console:
- IAM -> Roles -> Create role
- add EC2 service run
  - select EC2 with the Use case Service dropdown,
  - select EC2 (first option)
  - Click next  
- add AdministratorAccess  then select next.
- Add in a role name: Terraform-Admin
- Click Create role  

Attach role to EC2
- Go to EC2 instances
- select your instance
- Go to Actions dropdown button -> Security -> Modify IAM Role
- Attach the role you just created.

Verify role on the instance

Run these two commands to verify
- curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
- aws sts get-caller-identity


### 3. Install git
```bash
sudo dnf install git -y
```

### 4. Install terraform
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```

### 5. Clone the lab repository
```bash
git clone https://github.com/DHunnicuttSG/SRE_Labs.git
```

* Verify that the folder SRE_Labs is present.  

You MAY need to update a few items in the repo.  
* Change the region on line 3 of variables.tf if needed, **default is us-east-1**
* Change the key name on line 3 of terraform.tfvars to your key name.  **default is ServerKey**

### 6. Run terraform to create the lab

Move to the terraform folder
```bash
cd ~/SRE_Labs/terraform
```

Initialize terraform
```bash
terraform init
```

Create the terraform plan
```bash
terraform plan
```

Apply the plan
```bash
terraform apply
# type in yes when prompted
```

### 7. Log Into The Lab Environment
- Use the outputs on the screen to ssh into the new EC2 instance
```bash
docker ps
# you should see a list of all the containers up and running. 
```


