#  Terraform + AWS + Ansible DevOps Project

##  Overview
End-to-end Infrastructure as Code project using Terraform and Ansible.

### Objectives
- Create AWS network infrastructure via Terraform.
- Deploy EC2 instance with public subnet and internet access.
- Configure server automatically via Ansible (Docker + Nginx).
- Store state and artifacts in S3..

---

##  Architecture

```mermaid
graph TD;
  TF[Terraform] --> AWS[AWS Cloud];
  AWS --> VPC[VPC 10.0.0.0/16];
  VPC --> Subnet[Public Subnet 10.0.1.0/24];
  Subnet --> EC2[EC2 Instance (Ubuntu)];
  EC2 -->|Configured by| Ansible[Ansible Playbook];
  AWS --> S3[S3 Bucket for State];
  EC2 --> DockerNginx[Docker + Nginx];
