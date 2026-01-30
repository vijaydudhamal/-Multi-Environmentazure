#!/bin/bash

# Array of your environments
ENVIRONMENTS=("dev" "qa" "prod")

echo "🚀 Starting Terraform Validation for all environments..."
echo "-------------------------------------------------------"

for ENV in "${ENVIRONMENTS[@]}"
do
    echo "Checking Environment: [$ENV]"
    
    # Navigate to the environment folder
    cd environments/$ENV || { echo "❌ Folder environments/$ENV not found"; exit 1; }

    # Initialize (quietly) to ensure provider and modules are loaded
    terraform init -backend=false -input=false > /dev/null

    # Run the validation check
    terraform validate
    
    if [ $? -eq 0 ]; then
        echo "✅ $ENV is valid."
    else
        echo "❌ $ENV failed validation!"
        exit 1
    fi

    # Go back to root for the next iteration
    cd ../../
    echo "-------------------------------------------------------"
done

echo "🎉 All environments passed validation!"