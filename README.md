# wca.link

# Deploy

    # Verify what will happen in the deploy.
    make test

    # This may ask you to type `yes` to confirm.
    make deploy

## Lock

The deployment uses a lock. If something goes wrong (or you abort mid-deploy), the lock may never be released.
If this happens, `make deploy` should print the lock info, and you can use `terraform force-unlock [ID goes here]` to release the lock.

# Setup

## macOS

    brew install awscli terraform
    # See https://docs.google.com/document/d/1WYYUg5RukgCSA7Mt6xfQ1ZCpYzax8ksekcp8PMMBSOg/edit# for AWS CLI config
    aws configure
    terraform init
    terraform plan
