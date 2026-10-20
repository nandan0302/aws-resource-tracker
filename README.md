# AWS Resource Tracker Using Bash

## Overview

This project uses Bash Shell Scripting and the AWS CLI to generate an inventory report of AWS resources.

The script lists:
- Amazon S3 buckets
- Amazon EC2 instances and their states
- AWS Lambda functions
- AWS IAM users

The report is saved to `resourceTracker.txt`.

## Technologies Used

- Bash Shell Scripting
- AWS CLI
- `jq` for JSON parsing
- Git and GitHub

## Prerequisites

- AWS CLI installed and configured
- `jq` installed
- Bash shell available
- An AWS identity with the required read permissions

## How to Run

1. Clone this repository.
2. Navigate to the project directory.
3. Configure AWS credentials securely.
4. Make the script executable:

   ```bash
   chmod +x aws_resource_tracker.sh
   ```

5. Run the script:

   ```bash
   ./aws_resource_tracker.sh
   ```

6. View the generated report:

   ```bash
   cat resourceTracker.txt
   ```

## Output

The script generates a report containing the available S3 buckets, EC2 instance IDs and states, Lambda function names, and IAM usernames.

## Learning Objectives

- Automating AWS CLI commands using Bash
- Extracting resource information from JSON using `jq`
- Using output redirection to generate reports
- Practicing AWS resource inventory automation

## Security

Never commit AWS access keys, secret keys, or sensitive resource reports to GitHub. Use an IAM role where appropriate and grant only the permissions required by the script.

---

**Project status:** Initial version — AWS resource inventory automation.
