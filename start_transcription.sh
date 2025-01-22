#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <audio-file-path> <s3-bucket-name>"
    exit 1
fi

# Arguments
AUDIO_FILE_PATH=$1
S3_BUCKET=$2

# Extract the file name and extension
MEDIA_FILE=$(basename "$AUDIO_FILE_PATH")
MEDIA_FORMAT="${MEDIA_FILE##*.}"

# Check if a transcription job with the same name already exists
existing_job_status=$(aws transcribe get-transcription-job \
    --profile $AWS_PROFILE \
    --transcription-job-name $TRANSCRIPTION_JOB_NAME \
    --query 'TranscriptionJob.TranscriptionJobStatus' \
    --output text 2>/dev/null)

if [ "$existing_job_status" == "IN_PROGRESS" ] || [ "$existing_job_status" == "QUEUED" ]; then
    echo "A transcription job with the name $TRANSCRIPTION_JOB_NAME is already in progress."
    exit 1
elif [ "$existing_job_status" == "COMPLETED" ] || [ "$existing_job_status" == "FAILED" ]; then
    echo "Deleting existing transcription job: $TRANSCRIPTION_JOB_NAME"
    aws transcribe delete-transcription-job \
        --profile $AWS_PROFILE \
        --transcription-job-name $TRANSCRIPTION_JOB_NAME
fi

# Upload the audio file to the specified S3 bucket, overwriting if it exists
aws s3 cp "$AUDIO_FILE_PATH" s3://$S3_BUCKET/$MEDIA_FILE --profile $AWS_PROFILE --acl bucket-owner-full-control

# Start Transcription Job
aws transcribe start-transcription-job \
    --profile $AWS_PROFILE \
    --transcription-job-name $TRANSCRIPTION_JOB_NAME \
    --language-code $LANGUAGE_CODE \
    --media-format $MEDIA_FORMAT \
    --media MediaFileUri=s3://$S3_BUCKET/$MEDIA_FILE \
    --output-bucket-name $OUTPUT_BUCKET

echo "Transcription job started: $TRANSCRIPTION_JOB_NAME"
