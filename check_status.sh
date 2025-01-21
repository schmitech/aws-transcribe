#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Check Transcription Job Status
aws transcribe get-transcription-job \
    --profile $AWS_PROFILE \
    --transcription-job-name $TRANSCRIPTION_JOB_NAME
