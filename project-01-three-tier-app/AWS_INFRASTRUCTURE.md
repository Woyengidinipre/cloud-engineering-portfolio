# AWS Infrastructure Deployed

## Load Balancer
DNS: app20251019115732754300000009-732046316.eu-north-1.elb.amazonaws.com

## Database
Address: three-tier-app-db.c54q4aacu7ef.eu-north-1.rds.amazonaws.com
Endpoint: three-tier-app-db.c54q4aacu7ef.eu-north-1.rds.amazonaws.com:3306

## Network
VPC: vpc-0929221df682d2d40
VPC CIDR: 10.0.0.0/16

Public Subnets:
- subnet-04c28b981dfe4cf17
- subnet-0eae42c6220fa804d

Private Subnets:
- subnet-0d1852233f2ddab8d
- subnet-052d250aee61881cd

Database Subnets:
- subnet-090b9175ebcae4d87
- subnet-02b76e1e870ca49a6

NAT Gateways:
- nat-015e35492de0b345f
- nat-0afec16885ac9da38

## High Availability & Scaling
- ECS Cluster with auto-scaling (2-4 containers)
- Multi-AZ RDS Database
- Load Balancer distributing traffic
- CloudWatch monitoring enabled
