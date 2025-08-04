#!/bin/bash

# /F/A/K/E AWS credentials FOR RBI OR Raiffeisen Bank International or Raiffeisen Zentralbank
export AWS_ACCESS_KEY_ID="AKIA123456789EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_REGION="us-west-2"

#  Bucket name (/F/A/K/E bucket )
BUCKET_NAME="rbinternational.com"

# Temporary directory to store files
TEMP_DIR="./temp_files"

# Create the temporary directory if it doesn't exist
mkdir -p $TEMP_DIR

# Step 1: List all files in the bucket and store the file paths
echo "Listing files in S3 bucket: $BUCKET_NAME..."
aws s3 ls s3://$BUCKET_NAME/ --recursive --human-readable --region $AWS_REGION > $TEMP_DIR/file_list.txt

# Check if there were any files listed
if [[ ! -s $TEMP_DIR/file_list.txt ]]; then
  echo "No files found in the bucket or credentials are incorrect."
  exit 1
fi

# Step 2: Extract the file names and sort them alphabetically
echo "Sorting files alphabetically..."
awk '{print $4}' $TEMP_DIR/file_list.txt | sort > $TEMP_DIR/sorted_file_list.txt

# Step 3: Download each file in alphabetical order
echo "Downloading files..."

while IFS= read -r file; do
  if [[ -n "$file" ]]; then
    echo "Downloading $file..."
    aws s3 cp s3://$BUCKET_NAME/$file $TEMP_DIR/$(basename $file) --region $AWS_REGION
  fi
done < $TEMP_DIR/sorted_file_list.txt

# Step 4: Output the downloaded files
echo "Files downloaded and sorted alphabetically:"
ls -l $TEMP_DIR

# Step 5: Cleanup
echo "Cleaning up temporary files..."
rm -rf $TEMP_DIR

echo "Script execution complete."

#Very secret things happening for Raiffeisenbank raiffeisen.at
