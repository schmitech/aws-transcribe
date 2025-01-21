# AWS Transcribe Audio to Markdown

This project provides a set of scripts to transcribe audio files using AWS Transcribe and extract the conversation into a Markdown file. It includes shell scripts for managing transcription jobs and a Python script for processing the transcription output.

## Prerequisites

- **AWS CLI**: Ensure you have the AWS CLI installed and configured with your credentials.
- **Python**: Ensure you have Python installed on your system.
- **Virtual Environment**: Use a virtual environment to manage dependencies.
- **AWS Account**: You need an AWS account with permissions to use AWS Transcribe and S3.

## Project Structure

aws-transcribe-project/
│
├── start_transcription.sh
├── check_status.sh
├── retrieve_transcription.sh
├── extract_conversation.py
└── README.md


## Setup

1. **Configure AWS CLI**: Run `aws configure` to set up your AWS credentials and default region.

2. **Edit Scripts**: Update the shell scripts with your specific S3 bucket names, file names, and AWS profile.

## Usage

### Step 1: Start Transcription Job

Run the `start_transcription.sh` script to start a transcription job for your audio file.

```bash
./start_transcription.sh
```

### Step 2: Check Transcription Job Status

Run the `check_status.sh` script to check the status of your transcription job.

```bash
./check_status.sh
```

### Step 3: Retrieve Transcription Result

Once the transcription job is completed, run the `retrieve_transcription.sh` script to download the transcription result.


### Step 4: Extract Conversation

Use the `extract_conversation.py` script to extract the conversation from the JSON file and save it as a Markdown file.


### Step 4: Extract Conversation

Use the `extract_conversation.py` script to extract the conversation from the JSON file and save it as a Markdown file.


## Output

The conversation will be saved in a file named `podcast_conversation.md`, formatted in Markdown for easy reading. The JSON file will be deleted from the S3 bucket after processing.

## Notes

- **S3 Bucket Policies**: Ensure your S3 bucket policies allow access to AWS Transcribe.
- **AWS CLI Profile**: The scripts use the AWS CLI profile specified in the `.env` file. Make sure this profile is correctly configured.
- **Manual Cleanup**: Remember to manually delete completed transcription jobs from AWS Transcribe to avoid unnecessary charges and clutter. You can do this using the AWS Management Console or the AWS CLI:
  ```bash
  aws transcribe delete-transcription-job --transcription-job-name your-job-name --profile your-profile
  ```
- **Virtual Environment**: The virtual environment (`venv`) is excluded from version control via `.gitignore`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.