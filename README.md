# wca.link

# Deploy

    # Verify what will happen in the deploy.
    make test

    # This may ask you to type `yes` to confirm.
    make deploy

If you are asked for a region, enter: `us-west-2`.

## Lock

The deployment uses a lock. If something goes wrong (or you abort mid-deploy), the lock may never be released.
If this happens, `make deploy` should print the lock info, and you can use `terraform force-unlock [ID goes here]` to release the lock.

# Setup

## macOS

    brew install awscli terraform
    # Please configure with your own personal AWS credentials. Region should be "us-west-2", output format should be "json" (both without quotes).
    aws configure
    terraform init
    terraform plan

## Tests

    bundle install
