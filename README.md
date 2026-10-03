# gdbook-infra

Terraform configuration that creates the cloud server for the GDBook website on AWS:
one Ubuntu virtual machine, a firewall rule set, and an SSH key, all defined as code.

## What it creates

| Resource | Purpose |
| --- | --- |
| `aws_key_pair.deploy` | Uploads your SSH public key so you can log in |
| `aws_security_group.web` | Firewall: SSH only from your IP, HTTP from anywhere |
| `aws_instance.web` | Ubuntu 24.04 server; installs Nginx on first boot |

## Files

| File | Purpose |
| --- | --- |
| `versions.tf` | Terraform and AWS provider versions, region |
| `variables.tf` | Inputs: region, instance size, SSH key path, allowed IP |
| `main.tf` | The resources |
| `outputs.tf` | Prints the server IP, site URL and SSH command |
| `user_data.sh` | Script the server runs once on first boot |

## Use it

You need Terraform, an AWS account with credentials configured (`aws configure`),
and an SSH key (`ssh-keygen -t ed25519`).

```bash
cp terraform.tfvars.example terraform.tfvars   # then set your own IP
terraform init      # download the AWS provider
terraform plan      # show what would be created
terraform apply     # create it
```

`apply` prints the site URL and the SSH command. To remove everything:

```bash
terraform destroy
```

## How it works

- **State.** Terraform records what it created in `terraform.tfstate`. On the next
  `plan` it compares that file, the code and the real AWS account, and only changes
  what differs. The state file is kept out of Git because it can contain private data.
- **Data sources.** `data "aws_ami"` looks up the newest Ubuntu 24.04 image instead of
  hard-coding an image ID, which is different in every region.
- **Security group.** Port 22 is open only to `ssh_allowed_cidr`, so the server cannot
  be reached over SSH from the rest of the internet. Port 80 is open to everyone.
- **user_data.** A shell script passed to the instance and run once by cloud-init on
  first boot. It installs Nginx so the server answers as soon as it is up.
- **Variables and outputs.** Nothing personal is hard-coded: the region, key path and
  IP are inputs, and the address of the new server comes back as an output.

## Deploying the real site

The server starts with a placeholder page. To put the real site on it, copy the
`geo-books-server` project to the server and run its `setup_server.sh`.

## Cost

A `t3.micro` instance is covered by the AWS free tier for new accounts. Run
`terraform destroy` when you are done so nothing keeps running.
