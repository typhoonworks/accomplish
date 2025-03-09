#!/bin/bash

# Enable verbose output
set -x

# AWS CLI configuration
AWS_ENDPOINT_URL=http://localhost:4566
AWS_DEFAULT_REGION=${DEFAULT_REGION:-us-west-2}
BUCKET_NAME=${BUCKET_NAME:-files}

# Check AWS CLI installation
which aws
aws --version

# Verify endpoint connectivity
echo "Checking LocalStack endpoint..."
curl http://localhost:4566/health

echo "########### Attempting S3 Operations ###########"

# Try creating a bucket with extensive error checking
echo "Attempting to create bucket: $BUCKET_NAME"
aws --endpoint-url=$AWS_ENDPOINT_URL s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_DEFAULT_REGION" \
    --create-bucket-configuration LocationConstraint="$AWS_DEFAULT_REGION" \
    || (echo "Bucket creation failed" && exit 1)

# List buckets to verify
echo "Listing buckets:"
aws --endpoint-url=$AWS_ENDPOINT_URL s3api list-buckets

# Check bucket exists
aws --endpoint-url=$AWS_ENDPOINT_URL s3api head-bucket --bucket "$BUCKET_NAME" \
    || (echo "Bucket does not exist" && exit 1)

echo "S3 initialization complete!"
