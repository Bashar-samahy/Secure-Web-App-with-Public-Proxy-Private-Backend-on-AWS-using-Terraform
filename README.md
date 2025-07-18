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

### 2. **Security Groups**
- **bashar-pub-sg**: For proxy servers, allows HTTP/HTTPS/SSH from anywhere.
- **bashar-prv-sg**: For backend servers, allows traffic only from proxy SG and SSH.

### 3. **EC2 Instances**
- **Proxy Instances**: Named `bashar-proxy-1`, `bashar-proxy-2`, etc.  
  - Deployed in public subnets.
  - Accessible via SSH using `project.pem`.
  - Nginx installed via `remote-exec`.
- **Backend Instances**: Named `bashar-backend-1`, `bashar-backend-2`, etc.  
  - Deployed in private subnets.
  - Provisioned via proxy (bastion) host.
  - Receives files from `app_files/` directory.

### 4. **Application Load Balancer**
- **Public & Internal ALBs**: Distributes traffic to proxy and backend instances.

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
