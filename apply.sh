#!/bin/bash

# Define your environments
environments=("dev" "prod")

# Loop through each environment and run terraform apply -auto-approve
for environment in "${environments[@]}"; do
  echo "Running Terraform apply for environment: $environment"

  # Change directory to the environment folder
  cd "environments/$environment" || exit

  # Run terraform apply with auto-approval
  terraform apply -auto-approve

  # Move back to the root directory
  cd ../../ || exit

  echo "Terraform apply completed for environment: $environment"
  echo "----------------------------------------------"
done

echo "Terraform apply process completed for all environments"
