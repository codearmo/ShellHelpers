#!/bin/bash

# Exit immediately if a command fails
set -e

# Check that REDIS_PASSWORD is set
if [ -z "$REDIS_PASSWORD" ]; then
  echo "❌ REDIS_PASSWORD environment variable is not set."
  echo "Please export it in your shell or .bashrc before running this script."
  exit 1
fi

# Optional: create the volume directory if it doesn't exist
mkdir -p "$(pwd)/redis-data"

# Run the Redis container
docker run -d --name redis \
  --restart unless-stopped \
  --entrypoint "" \
  -p 6379:6379 \
  -v "$(pwd)/redis-data":/data \
  redislabs/redismod \
  redis-server --requirepass "$REDIS_PASSWORD" --dir /data

echo "✅ Redis container started with password authentication enabled."
