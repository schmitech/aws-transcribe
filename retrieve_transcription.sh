#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Function to check the status of the transcription job
check_status() {
    local status
    echo "Waiting for transcription job to complete..."
    while true; do
        status=$(aws transcribe get-transcription-job \
            --profile $AWS_PROFILE \
            --transcription-job-name $TRANSCRIPTION_JOB_NAME \
            --query 'TranscriptionJob.TranscriptionJobStatus' \
            --output text)

        if [ "$status" == "COMPLETED" ]; then
            echo "Transcription job completed."
            break
        elif [ "$status" == "FAILED" ]; then
            echo "Transcription job failed."
            exit 1
        fi

        sleep 30  # Wait for 30 seconds before checking again
    done
}

# Check the status of the transcription job
check_status

# Retrieve Transcription Result
aws s3 cp s3://$OUTPUT_BUCKET/$TRANSCRIPTION_JOB_NAME.json . \
    --profile $AWS_PROFILE

echo "Transcription result downloaded: $TRANSCRIPTION_JOB_NAME.json"

# Call the Python script to extract the conversation
python extract_conversation.py

# Delete the transcription JSON file from the S3 bucket
aws s3 rm s3://$OUTPUT_BUCKET/$TRANSCRIPTION_JOB_NAME.json \
    --profile $AWS_PROFILE

echo "Transcription result deleted from S3 bucket: $OUTPUT_BUCKET"