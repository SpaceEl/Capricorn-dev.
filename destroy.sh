#!/bin/bash

# Define your environments
environments=("dev" "prod")

# Loop through each environment and run terraform destroy -auto-approve
for environment in "${environments[@]}"; do
  echo "Running Terraform destroy for environment: $environment"

  # Change directory to the environment folder
  cd "environments/$environment" || exit

  # Run terraform destroy with auto-approval
  terraform destroy -auto-approve

  # Move back to the root directory
  cd ../../ || exit

  echo "Terraform destroy completed for environment: $environment"
  echo "----------------------------------------------"
done

echo "Terraform destroy process completed for all environments"