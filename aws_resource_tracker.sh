
#!/bin/bash

# Author: Nandan
# Purpose: AWS Resource Tracker with S3 and SNS
# Version: v4

set -e
set -o pipefail

# Configuration
REPORT_BUCKET="aws-resource-tracker-28"
S3_PREFIX="aws-resource-tracker"
SNS_TOPIC_ARN="arn:aws:sns:ap-south-1:905765460137:aws-resource-tracker-notifications"
AWS_REGION="ap-south-1"

# Generate a timestamped report
REPORT_FILE="resourceTracker_$(date +%Y-%m-%d_%H-%M-%S).txt"

echo "===== AWS RESOURCE TRACKER =====" > "$REPORT_FILE"
echo "Generated at: $(date)" >> "$REPORT_FILE"

# List S3 buckets
echo "" >> "$REPORT_FILE"
echo "===== S3 BUCKETS =====" >> "$REPORT_FILE"
aws s3 ls --region "$AWS_REGION" >> "$REPORT_FILE"

# List EC2 instances
echo "" >> "$REPORT_FILE"
echo "===== EC2 INSTANCES =====" >> "$REPORT_FILE"
aws ec2 describe-instances --region "$AWS_REGION" \
  | jq -r '.Reservations[].Instances[] |
    "Instance ID: \(.InstanceId) | State: \(.State.Name)"' \
  >> "$REPORT_FILE"

# List Lambda functions
echo "" >> "$REPORT_FILE"
echo "===== LAMBDA FUNCTIONS =====" >> "$REPORT_FILE"
aws lambda list-functions --region "$AWS_REGION" \
  | jq -r '.Functions[].FunctionName' >> "$REPORT_FILE"

# List IAM users
echo "" >> "$REPORT_FILE"
echo "===== IAM USERS =====" >> "$REPORT_FILE"
aws iam list-users --region "$AWS_REGION" \
  | jq -r '.Users[].UserName' >> "$REPORT_FILE"

# Upload report to S3
S3_URI="s3://${REPORT_BUCKET}/${S3_PREFIX}/${REPORT_FILE}"

aws s3 cp "$REPORT_FILE" "$S3_URI" --region "$AWS_REGION"

# Send email notification only after successful upload
aws sns publish \
  --region "$AWS_REGION" \
  --topic-arn "$SNS_TOPIC_ARN" \
  --subject "AWS Resource Tracker: Report Uploaded" \
  --message "The AWS resource report was uploaded successfully.

Report: $REPORT_FILE
S3 location: $S3_URI
Generated at: $(date)"

echo "Report generated, uploaded, and notification sent successfully."
