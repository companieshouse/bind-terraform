# Bind CHS 

README.md


# CHS-BIND DNS Platform

This repository provisions and configures **BIND DNS servers** for Companies House infrastructure using:

-  Terraform (infrastructure provisioning)
-  Ansible (configuration management)
-  S3 (authoritative zone storage)
-  Concourse CI (deployment pipeline)

The platform is designed for:

- High availability (master/slave architecture)
- Idempotent configuration
- CI/CD-driven operations
- Centralised DNS zone management
- Auditability and change tracking



# Architecture Overview



Terraform → AWS EC2 + Route53 + IAM
↓
Ansible → Configure BIND service
↓
S3 → Zone file distribution
↓
Master → Slave replication (AXFR)



---

#Repository Structure



ansible/
├── playbooks/
│   └── site.yml
├── inventories/
│   └── <environment>/
├── roles/
│   ├── bind\_install/
│   ├── bind\_configure/
│   ├── bind\_zones/
│   └── bind\_service/
├── group\_vars/
│   └── bind.yml



---

# Deployment Flow

## Step 1: Provision Infrastructure (Terraform)

- EC2 instances (BIND servers)
- Security groups
- IAM instance profiles
- Route53 records

bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan


***

## Step 2: Configure Servers (Ansible)

bash
ansible-playbook \
  -i inventories/<env>/hosts.yml \
  playbooks/site.yml


***

# Ansible Role Breakdown

***

## 1. Role: `bind_install`

### Purpose

Installs BIND packages and manages service lifecycle.

### Responsibilities

* Install `bind` and `bind-utils`
* Enable and start `named`

### Behaviour

* Idempotent
* OS-compatible (Amazon Linux / RHEL)

***

## 2. Role: `bind_configure`

### Purpose

Configures core BIND service (`named.conf`).

### Responsibilities

* Configure master / slave roles
* Define listen interfaces
* Configure ACLs (query / transfer)
* Apply security policies

### Key Variables

yaml
bind_configure_role: master | slave

bind_configure_allow_query:
  - any

bind_configure_allow_transfer:
  - 10.0.1.10

bind_configure_masters:
  - 10.0.1.10


### Features

* Master/slave behaviour enforcement
* Secure zone transfers
* Config validation (`named-checkconf`)

***

## 3. Role: `bind_zones`

### Purpose

Manages DNS zone files and ensures they are valid and synchronised.

### Responsibilities

* Sync zone files from S3
* Validate zone files
* Reload BIND service safely

***

### Source of Truth

**S3 is the authoritative source of zone files**


s3://<bind_zone_bucket>/zones/


***

### Key Tasks

#### Sync zones

yaml
aws s3 sync s3://<bucket>/zones/ /var/named/


#### Validate zones

bash
named-checkzone <zone> <zonefile>


***

### Key Variables

yaml
bind_zones_zone_bucket: chs-bind-zones
bind_zones_zone_prefix: zones
bind_zones:
  - zone: example.internal
    file: example.internal.zone


***

## 4. Role: `bind_service`

### Purpose

Manages DNS records dynamically at the **service level**, enabling automation of:

* A records
* CNAME records
* PTR records
* SRV records

***

### Responsibilities

* Create/update/delete DNS records
* Validate record structure
* Maintain audit trail (optional extension)
* Ensure idempotency

***

### Example Input

yaml
bind_service_records:
  - name: api
    zone: example.internal
    type: A
    value: 10.0.10.5
    state: present
    owner: platform

  - name: db
    zone: example.internal
    type: CNAME
    value: db.internal
    state: present


***

### Supported Record Types

| Type  | Supported |
| ----- | --------- |
| A     | ✅         |
| AAAA  | ✅         |
| CNAME | ✅         |
| PTR   | ✅         |
| SRV   | ✅         |

***

### Features

* Record validation
* Idempotent updates
* Record removal support
* Extensible for audit logging

***

# Master / Slave Behaviour

| Role        | Behaviour               |
| ----------- | ----------------------- |
| Master      | Pulls zones from S3     |
| Slave       | Receives zones via AXFR |
| Zones       | Stored centrally        |
| Replication | DNS zone transfer       |

***

# Security Model

* IAM roles used for S3 access
* No static credentials on instances
* Zone transfers restricted via ACL
* DNS recursion disabled by default
* SSM preferred over SSH

***

# DNS Flow


Client → Route53 → BIND EC2 → Zone response


***

# Validation & Testing

## Validate configuration

bash
named-checkconf


## Validate zones

bash
named-checkzone example.internal /var/named/example.internal.zone


## Query DNS

bash
dig @<bind-server-ip> example.internal


***

# CI/CD Pipeline Integration

Pipeline stages:


1. Git push
2. Release (versioning)
3. Terraform plan
4. Terraform apply
5. Ansible deploy
6. DNS available


***

#  Requirements

* Ansible ≥ 2.15
* AWS CLI installed on target hosts
* IAM role with S3 read access
* BIND packages available via OS repository

***

# Design Principles

* Single source of truth (S3 for zones)
* Separation of concerns (roles)
* Idempotency
* Infrastructure as Code
* CI/CD driven deployment
* Lint-clean Ansible roles


This platform provides a **scalable, secure, and fully automated DNS solution** using:

* Terraform → infrastructure
* Ansible → configuration
* S3 → zone data
* CI/CD → deployment

***

Terraform provisions servers
Ansible configures BIND
S3 provides zone data
BIND serves DNS
