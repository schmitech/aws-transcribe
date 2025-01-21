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
