#!/bin/bash
echo "Executing Pre-API Helpers"
echo "Rescan github.com public SSH key"
echo "Ref: https://github.blog/2023-03-23-we-updated-our-rsa-ssh-host-key/"
ssh-keyscan github.com >> ~/.ssh/known_hosts
echo "Remove AWS Profile"
export AWS_PROFILE_ORIG=$AWS_PROFILE
unset AWS_PROFILE
echo "End of Removing AWS Profile"
echo "Begin of getting parameter"
aws ssm get-parameter --name /aft/resources/git-keys/Flutter-Global/github-dtpl-terraform-modules --with-decryption --query 'Parameter.Value' --output text > /tmp/github_dtpl_terraform_modules_key
echo "End of getting parameter"
echo "Begin of changing file permissions"
chmod 400 /tmp/github_dtpl_terraform_modules_key
echo "End of changing file permissions"
echo "export GIT_SSH_COMMAND=\"ssh -o IdentitiesOnly=yes -i /tmp/github_dtpl_terraform_modules_key\"" >> $DEFAULT_PATH/aft-venv/bin/activate
echo "Returning target profile"
export AWS_PROFILE=$AWS_PROFILE_ORIG
