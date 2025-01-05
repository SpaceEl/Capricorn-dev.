#!/bin/bash

# Define your environments
environments=("dev" "prod")

# Loop through each environment and run terraform init
for environment in "${environments[@]}"; do
  echo "Initializing Terraform for environment: $environment"
  
  # Change directory to the environment folder
  cd "environments/$environment" || exit

  # Run terraform init
  terraform init

  # Move back to the root directory
  cd ../../ || exit

  echo "Terraform init completed for environment: $environment"
  echo "----------------------------------------------"
done

echo "Terraform init process completed for all environments"