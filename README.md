# wca.link

# Deploy

    # Verify what will happen in the deploy.
    make test

    # This may ask you to type `yes` to confirm.
    make deploy

# Setup

## macOS

    brew install awscli terraform
    # See https://docs.google.com/document/d/1WYYUg5RukgCSA7Mt6xfQ1ZCpYzax8ksekcp8PMMBSOg/edit# for AWS CLI config
    aws configure
    terraform init
    terraform plan
