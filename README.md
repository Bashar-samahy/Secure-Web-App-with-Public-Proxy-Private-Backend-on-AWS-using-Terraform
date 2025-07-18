# 🚀 TF-PROJECT: Terraform AWS Infrastructure

Welcome to **TF-PROJECT**!  
This project uses Terraform to provision a multi-tier AWS infrastructure including VPC, subnets, security groups, EC2 instances, and an Application Load Balancer.

---

## 📁 Project Structure

```
TF-PROJECT/
│
├── app_files/                        # Files to be provisioned on backend EC2 instances
│   └── (your application files here)
│
├── main.tf                           # Root Terraform configuration
├── variables.tf                      # Root variables
├── outputs.tf                        # Root outputs
├── project.pem                       # AWS EC2 key pair (private key)
│
├── Instances/
│   ├── main.tf                       # EC2 instance definitions (proxy & backend)
│   ├── variables.tf                  # Instance module variables
│   └── outputs.tf                    # Instance module outputs
│
├── VPC/
│   ├── main.tf                       # VPC resource definition
│   ├── variables.tf                  # VPC module variables
│   └── outputs.tf                    # VPC module outputs
│
├── Subnets/
│   ├── main.tf                       # Subnet resources
│   ├── variables.tf                  # Subnet module variables
│   └── outputs.tf                    # Subnet module outputs
│
├── SecurityGroups/
│   ├── main.tf                       # Security group resources
│   ├── variables.tf                  # Security group module variables
│   └── outputs.tf                    # Security group module outputs
│
├── Gateways/
│   ├── main.tf                       # IGW and NAT Gateway resources
│   ├── variables.tf                  # Gateway module variables
│   └── outputs.tf                    # Gateway module outputs
│
├── Routes/
│   ├── main.tf                       # Route table resources
│   ├── variables.tf                  # Route module variables
│   └── outputs.tf                    # Route module outputs
│
├── ELB/
│   ├── main.tf                       # Application Load Balancer resources
│   ├── variables.tf                  # ELB module variables
│   └── outputs.tf                    # ELB module outputs
│
└── README.md                         # Project documentation
```

---

## 🛠️ How It Works

### 1. **VPC & Subnets**
- **VPC**: Named `bashar-vpc-1`, provides network isolation.
- **Subnets**: Public and private subnets for proxy and backend instances.

![terraform-3](https://github.com/user-attachments/assets/9e9fcf17-5f41-45cc-809e-33f5e6797ee2)


### 2. **Security Groups**
- **bashar-pub-sg**: For proxy servers, allows HTTP/HTTPS/SSH from anywhere.
- **bashar-prv-sg**: For backend servers, allows traffic only from proxy SG and SSH.

<img width="1622" height="323" alt="image" src="https://github.com/user-attachments/assets/20ae05d6-eaf3-44a9-b2de-3efb4cb5a60e" />


### 3. **EC2 Instances**
- **Proxy Instances**: Named `bashar-proxy-1`, `bashar-proxy-2`, etc.  
  - Deployed in public subnets.
  - Accessible via SSH using `project.pem`.
  - Nginx installed via `remote-exec`.
- **Backend Instances**: Named `bashar-backend-1`, `bashar-backend-2`, etc.  
  - Deployed in private subnets.
  - Provisioned via proxy (bastion) host.
  - Receives files from `app_files/` directory.

![terraform-7](https://github.com/user-attachments/assets/e0f2cbe1-2868-48e0-a1c2-3c70ef059795)

### 4. **Application Load Balancer**
- **Public & Internal ALBs**: Distributes traffic to proxy and backend instances.

![terraform-5](https://github.com/user-attachments/assets/551bdb68-d44c-490d-9a8f-87bf3c166eb7)

![terraform-4](https://github.com/user-attachments/assets/ba4a4ce4-d6f2-4149-b827-94375401762d)


### 5. **Provisioners**
- **remote-exec**: Runs commands on EC2 after creation (e.g., install Nginx).
- **file**: Copies files from `app_files/` to backend EC2s via SSH (using proxy as bastion).



---

## 🔑 SSH Access

- **Key Pair**:  
  - Download `project.pem` from AWS and place it in the project root.
  - Set permissions:  
    ```sh
    chmod 400 project.pem
    ```
- **Connect to Proxy**:  
  ```sh
  ssh -i project.pem ec2-user@<proxy_public_ip>
  ```
- **Connect to Backend (via Proxy)**:  
  Use SSH agent forwarding or ProxyJump.

![terraform-9](https://github.com/user-attachments/assets/a822d76f-40a7-421a-9e25-bdc68148a6be)
![terraform-10](https://github.com/user-attachments/assets/5e520092-ea1e-44e2-8d46-e064407ce015)


---

## ⚙️ How to Deploy

1. **Initialize Terraform**  
   ```sh
   terraform init
   ```

2. **Review/Set Variables**  
   - Edit `variables.tf` for AMI IDs, subnet CIDRs, etc.

3. **Apply the Configuration**  
   ```sh
   terraform apply
   ```
   - Review the plan and confirm.

4. **Check Outputs**  
   - Find public IPs, ALB DNS, and SSH commands in `terraform output`.

![terraform-1](https://github.com/user-attachments/assets/2f7a50fa-b987-4e96-a547-8e69ef45641d)
![terraform-2](https://github.com/user-attachments/assets/e3457226-2660-4c04-aaa3-4aaeb2bdbfb8)


---

## 📝 Troubleshooting

- **Module not installed**: Run `terraform init`.
- **SSH errors**:  
  - Ensure `project.pem` matches the AWS key pair name.
  - Use correct username (`ec2-user` for Amazon Linux).
  - Security group allows SSH (port 22).
- **Provisioner errors**:  
  - Ensure `host` is set in all `connection` blocks.
  - For backend, use `self.private_ip` and bastion settings.
- **File not found**:  
  - Make sure `app_files/` exists and contains files to copy.

---

## 📦 Outputs

- **ALB DNS**:  
  - `terraform output public_alb_dns`
- **Proxy Public IPs**:  
  - `terraform output proxy_public_ips`
- **Backend Private IPs**:  
  - `terraform output backend_private_ips`
- **SSH Command Example**:  
  - `terraform output ssh_command`

![terraform-8](https://github.com/user-attachments/assets/516478b4-4105-40b0-b224-d11874c1c280)


---

## 🧹 Clean Up

To destroy all resources:
```sh
terraform destroy
```

---

## 💡 Tips

- Always keep your `project.pem` secure!
- Use AWS Console to monitor resource creation and troubleshoot networking issues.
- For production, restrict SSH access and use SSM Session Manager.

---

## 🙋 Need Help?

If you encounter issues, check error messages and review the troubleshooting section above.  
- For production, restrict SSH access and use SSM Session Manager.

---

## 🙋 Need Help?

If you encounter issues, check error messages and review the troubleshooting section above.  
For more details, see the [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

---

Happy Terraforming! 🌍🚦🖥️
