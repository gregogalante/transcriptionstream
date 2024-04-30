#!/bin/bash

# Initialize an empty string for build arguments
build_args=""

# Adjust the path to the .env file
env_file=".env"

# Check if the .env file exists
if [ ! -f "$env_file" ]; then
		echo "Error: .env file does not exist at $env_file"
		exit 1
fi

# Read each line from .env, ignoring comments and empty lines
while IFS= read -r line; do
		if [[ ! $line =~ ^#.*$ ]] && [[ -n $line ]]; then
				build_args="$build_args --build-arg $line"
		fi
done < "$env_file"

# Create necessary Docker volumes
echo "Creating Docker volumes..."
docker volume create --name=transcriptionstream

# Re-build the docker-compose services
echo "Building services with docker-compose..."
docker-compose -f docker-compose-dev.yml build $build_args

# Start the docker-compose services
echo "Starting services with docker-compose..."
docker-compose -f docker-compose-dev.yml up --detach

# Re-attach to compose logs
echo "Re-attaching to console logs"
docker-compose logs -f

echo "All services are up and running."
