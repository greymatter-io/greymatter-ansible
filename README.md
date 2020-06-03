#### Deploy Greymatter ####

# Install dependencies #

Ansible - (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

Terraform - (https://learn.hashicorp.com/terraform/getting-started/install.html)

Aws-cli - (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

# Export aws credentiials #

export AWS_ACCESS_KEY_ID='access_key_id'

export AWS_SECRET_ACCESS_KEY='secret_access_key'

export AWS_DEFAULT_REGION=region

Run 'aws configure --profile gm' and add the above credentials

# Create terraform backend #

aws s3 create-bucket --bucket "unique_terraform_backend_bucket_name"

Update terraform backend value in terraform/modules/main.tf with the "unique_terraform_backend_bucket_name"

export TERRAFORM_BACKEND_BUCKET="unique_terraform_backend_bucket_name"

# Export nexus credentials #

export NEXUS_USER=nexus_email

export NEXUS_PW='nexus_password'

# Export GM Control env vars #

export GM_CONTROL_AWS_AWS_ACCESS_KEY_ID=access_key_id

export GM_CONTROL_AWS_AWS_SECRET_ACCESS_KEY=secret_access_key

export GM_CONTROL_AWS_AWS_REGION=region

# Run ansible playbook #

ansible-playbook playbooks/greymatter_deployment.yml

Or to deploy individual services add '--tags "service_a,service_b"'

#### Destroy Greymatter ####

ansible-playbook playbooks/greymatter_destroy.yml





