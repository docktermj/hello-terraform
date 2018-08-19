# Hello terraform

This is an example of how to deploy "infrastructure as a service" via [Terraform](https://www.terraform.io/).

## Dependencies

### Hashicorp Terraform

Install the following DevOps tooling to deploy this demo environment:

* [Terraform](https://www.terraform.io/downloads.html) by HashiCorp

On a Mac, if you see "Your security preference allow installation...",
see [Your security preferences allow installation of only apps from the Mac App Store and identified developers](https://discussions.apple.com/thread/4180691)

### SSH public / private keys

Make sure your public SSH key is at `~/.ssh/id_rsa.pub`
and your private SSH key is at `~/.ssh/id_rsa`.
The private SSH key is used to SSH artifacts to the AWS EC2 machines,
it is *not* copied to the machines.

## Initialize

Get repository.

Initialize terraform.

```console
cd ~/docktermj.git/hello-terraform
terraform init
```

Install AWS credentials.

Find or create AWS Security Credentials for your account.
Unless you already have your AWS security credentials and can find them,
you'll need to create new security credentials.
Except at creation time, AWS will not show your security credentials.

Steps to creating new AWS Security Credentials:

1. Visit [Your Security Credentials](https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credential)
1. Expand "Access keys"
1. Click "Create New Access Key" button
1. *IMPORTANT:*  Save "Access Key ID" and "Secret Access Key" as AWS will never give you the "Secret Access Key" again.

With your security credentials, create a `~/.aws/credentials` file.

```console
mkdir -p ~/.aws
mv ~/.aws/credentials ~/.aws/credentials.$(date +%s)

cat <<EOT > ~/.aws/credentials
[default]
aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
EOT

chmod 770 ~/.aws
chmod 750 ~/.aws/credentials
```

## Configure

Copy [terraform.tfvars.sample](terraform.tfvars.sample) to `terraform.tfvars`.

If non-default values are desired, edit the [terraform.tfvars](terraform.tfvars).

## Lifecycle

### Dry-Run

This command tests the configuration file, `terraform.tfvars`.

```console
terraform plan -var-file terraform.tfvars
```

### Deploy

This command will perform the deployment into the AWS environment.

```console
terraform apply -var-file terraform.tfvars
```

#### Examine Deployment Results

This is useful to determine assigned public ip addresses and so on.

```console
terraform output
```

Example output:

```console
Outputs:

private_ips_for_app_nodes = [
    10.0.0.100
]
public_ips_for_app_nodes = [
    54.152.126.10
]
resource_prefix = michael-4815-model
ssh_example_app_passwordless = ssh centos@54.152.126.10
```

For more details:

```console
terraform show
```

You can visit the [AWS EC2 console](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:sort=tag:Name)
to see the AWS EC2 node details.

The EC2 instances have the following naming convention:

```console
<username>-<deployment_id>-<topology_name>-<role>-<role_variant>-ec2-<node_number>
```

Example:

```console
michael-2aca-model-app-default-ec2-0
```

### Test

#### SSH

Using `terraform output` you will have ssh information to get to the app, bare, data, and desktop nodes.

Using the username and password found in *admin_username_and_password* you can `ssh`
into any of the public IP addresses
(*public_ips_for_app_nodes*).

```console
 ssh <username>@nnn.nnn.nnn.nnn
```

Example:

```console
ssh admin@18.233.139.156
```

#### Password-less SSH

Using `terraform output` you will have ssh information to get to the app, bare, data, and desktop nodes.

Given the following information for the app node:

```console
ssh_example_app_passwordless = ssh centos@54.152.126.10
```

You can SSH to the app node by issuing:

```console
ssh centos@54.152.126.10
```

### Destroy

When finished using your cloud formation, destroy it with:

```console
terraform destroy
```
