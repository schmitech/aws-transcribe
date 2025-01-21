#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Retrieve Transcription Result
aws s3 cp s3://$OUTPUT_BUCKET/$TRANSCRIPTION_JOB_NAME.json . \
    --profile $AWS_PROFILE

echo "Transcription result downloaded: $TRANSCRIPTION_JOB_NAME.json"

# Call the Python script to extract the conversation
python extract_conversation.py

# Delete the transcription JSON file from the S3 bucket
aws s3 rm s3://$OUTPUT_BUCKET/$TRANSCRIPTION_JOB_NAME.json \
    --profile $AWS_PROFILE

echo "Transcription result deleted from S3 bucket: $TRANSCRIPTION_JOB_NAME.json"