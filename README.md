# Terraform HA 3-Tier Architecture

Terraform configuration that provisions a **3-tier architecture** in AWS, including:  
**VPC** with **9 subnets** for HA (Public, Private App, Private DB)  

## Overview
- **VPC CIDR:** `10.16.0.0/16`
- **Subnets:**
  - **Public (Web Layer):** `/24`  
  - **Private App Layer:** `/24`
  - **Private DB Layer:** `/24`

## Usage
1. **Initialize Terraform**  
   ```sh
   terraform init

2. **Plan**  
   ```sh
   AWS_PROFILE=your-aws-profile terraform plan

3. **Deploy**  
   ```sh
   AWS_PROFILE=your-aws-profile terraform apply -auto-approve

## Cleanup

**Destroy**  
   ```sh
   AWS_PROFILE=your-aws-profile terraform destroy -auto-approve


