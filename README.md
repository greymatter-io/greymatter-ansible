#### Deploy Greymatter ####

# Export aws credentiials #

export AWS_ACCESS_KEY_ID='access_key_id'

export AWS_SECRET_ACCESS_KEY='secret_access_key'

export AWS_DEFAULT_REGION=region

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

ansible-playbook -i inventories/aws_ec2.yml playbooks/greymatter_deployment.yml

#### Destroy Greymatter ####

ansible-playbook -i inventories/aws_ec2.yml playbooks/greymatter_destroy.yml





