#!/bin/bash

# Author: Nandan
# Date: 20-Oct-2026
# Version: v3
# Purpose: Generate AWS resource inventory report

set -e
set -o pipefail

# List S3 buckets
echo "===== S3 BUCKETS ====="
aws s3 ls > resourceTracker.txt

# List EC2 instances and their states
echo "===== EC2 INSTANCES =====" >> resourceTracker.txt
aws ec2 describe-instances \
  | jq -r '.Reservations[].Instances[] | "Instance ID: \(.InstanceId) | State: \(.State.Name)"' \
  >> resourceTracker.txt

# List Lambda functions
echo "===== LAMBDA FUNCTIONS =====" >> resourceTracker.txt
aws lambda list-functions \
  | jq -r '.Functions[].FunctionName' \
  >> resourceTracker.txt

# List IAM users
echo "===== IAM USERS =====" >> resourceTracker.txt
aws iam list-users \
  | jq -r '.Users[].UserName' \
  >> resourceTracker.txt

# Display report
cat resourceTracker.txt

echo "AWS resource report generated successfully!"
