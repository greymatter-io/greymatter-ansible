#### Deploy Greymatter ####

# Deploy infrastructure #

cd terraform

terraform get

terraform init

terraform apply

# Initialize dynamic inventory #

export AWS_ACCESS_KEY_ID='access_key_id'

export AWS_SECRET_ACCESS_KEY='secret_access_key'

export ANSIBLE_HOSTS=/etc/ansible/ec2.py

export EC2_INI_PATH=/etc/ansible/ec2.ini

eval 'ssh-agent'
ssh-add ~/.ssh/keypair.pem 

# Export nexus credentials #

export NEXUS_USER=nexus_email

export NEXUS_PW='nexus_password'

# Export GM Control env vars #

export GM_CONTROL_AWS_AWS_ACCESS_KEY_ID=access_key_id

export GM_CONTROL_AWS_AWS_SECRET_ACCESS_KEY=secret_access_key

export GM_CONTROL_AWS_AWS_REGION=region

export GM_CONTROL_AWS_VPC_ID="{vpc_id}"

# Run ansible playbook #

ansible-playbook -i /etc/ansible/ec2.py playbooks/greymatter_deployment.yml

#### Destroy Greymatter ####

rm ansible/playbooks/roles/ansible-role-acert/files/sidecar.tgz

rm ansible/playbooks/roles/ansible-role-ijwt-secrets/files/ijwt_secrets.tgz

cd terraform

terraform destroy







