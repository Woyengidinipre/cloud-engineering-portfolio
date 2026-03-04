# Three-Tier Scalable Web Application on AWS

A production-ready three-tier web application deployed on AWS using Terraform. Built as part of my cloud engineering portfolio to demonstrate end-to-end infrastructure provisioning, containerisation, high availability, and observability.

## Architecture

```
Internet
    │
    ▼
Application Load Balancer (Public Subnets)
    │
    ▼
ECS Fargate - Backend API (Private Subnets)
    │
    ▼
RDS MySQL Multi-AZ (Database Subnets)
```

The infrastructure is spread across 2 availability zones in `eu-north-1` with separate public, private, and database subnet tiers.

## Tech Stack

- **Cloud:** AWS (ECS Fargate, RDS, ALB, VPC, CloudWatch, IAM)
- **IaC:** Terraform
- **Backend:** Node.js running in Docker containers on ECS Fargate
- **Database:** MySQL 8.0 on RDS
- **Orchestration:** Docker, ECS with Auto Scaling

## Infrastructure Breakdown

### Networking (main.tf)
- VPC with CIDR `10.0.0.0/16`
- 6 subnets across 2 AZs: 2 public, 2 private, 2 database
- NAT Gateways in each AZ for high availability
- DNS hostnames and support enabled

### Load Balancer (alb.tf)
- Internet-facing Application Load Balancer in public subnets
- HTTP listener on port 80 forwarding to backend target group
- Health checks against `/health` endpoint
- Security group allowing HTTP/HTTPS from anywhere, forwarding only to ECS tasks on port 3000

### Compute (ecs.tf)
- ECS Cluster with Container Insights enabled for monitoring
- Fargate task definition: 256 CPU, 512MB memory
- ECS Service running 2 tasks minimum across private subnets
- Auto Scaling policy: scales between 2-4 containers based on CPU utilisation (target: 70%)
- IAM Task Execution Role with least-privilege permissions
- CloudWatch Log Group with 7-day retention

### Database (rds.tf)
- RDS MySQL 8.0 on `db.t3.micro`
- Multi-AZ deployment for high availability
- Automated backups with 7-day retention
- Storage encryption enabled
- Security group restricting access to ECS tasks only on port 3306
- Randomly generated 16-character password via Terraform

## Key Design Decisions

- **Private subnets for compute** — ECS tasks are not publicly accessible, all traffic flows through the ALB
- **Database subnet isolation** — RDS sits in a dedicated subnet tier with no direct internet access
- **Multi-AZ everything** — both the NAT Gateways and RDS are deployed across 2 AZs to eliminate single points of failure
- **Auto Scaling on CPU** — containers scale automatically under load without manual intervention
- **Terraform modules** — used the community `terraform-aws-modules/vpc/aws` module for reliable, battle-tested VPC provisioning

## Infrastructure Deployed

| Resource | Value |
|----------|-------|
| Load Balancer | `app20251019115732754300000009-732046316.eu-north-1.elb.amazonaws.com` |
| Database Endpoint | `three-tier-app-db.c54q4aacu7ef.eu-north-1.rds.amazonaws.com:3306` |
| VPC | `vpc-0929221df682d2d40` — `10.0.0.0/16` |
| Region | `eu-north-1` |

## How to Deploy

```bash
# Clone the repo
git clone https://github.com/Woyengidinipre/cloud-engineering-portfolio.git
cd cloud-engineering-portfolio/project-01-three-tier-app/infrastructure/terraform

# Initialise Terraform
terraform init

# Preview changes
terraform plan

# Deploy
terraform apply

# Destroy when done
terraform destroy
```

> **Note:** You will need AWS credentials configured and a backend image URI set in your variables before deploying.

## Lessons Learned

- NAT Gateway costs add up fast in multi-AZ setups, always destroy when not in use
- ECS Fargate task sizing matters, starting too small causes container restarts under load
- Terraform state should be stored remotely in S3 for any real team environment
- Health check paths need to exist on the backend before the ALB will mark targets as healthy

## Cost

Maintained under $50/month during active development through right-sizing and destroying resources when not in use.
