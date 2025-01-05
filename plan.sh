#!/bin/bash

# Define your environments
environments=("dev" "prod")

# Loop through each environment and run terraform plan
for environment in "${environments[@]}"; do
  echo "Running Terraform plan for environment: $environment"

  # Change directory to the environment folder
  cd "environments/$environment" || exit

  # Run terraform plan
  terraform plan

  # Move back to the root directory
  cd ../../ || exit

  echo "Terraform plan completed for environment: $environment"
  echo "----------------------------------------------"
done

echo "Terraform plan process completed for all environments"
