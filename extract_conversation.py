import json
import re
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def extract_conversation(json_file_path, output_file_path):
    # Load the JSON data from the file
    with open(json_file_path, 'r') as file:
        data = json.load(file)
    
    # Extract the transcript text
    transcript = data.get('results', {}).get('transcripts', [{}])[0].get('transcript', '')

    # Split the transcript into sentences
    sentences = re.split(r'(?<=[.!?]) +', transcript)

    # Simulate dialogue by alternating speakers
    speaker_labels = ["Speaker 1", "Speaker 2"]
    formatted_transcript = []
    for i, sentence in enumerate(sentences):
        speaker = speaker_labels[i % 2]
        formatted_transcript.append(f"**{speaker}:** {sentence}")

    # Write the formatted transcript to a Markdown file
    with open(output_file_path, 'w') as file:
        file.write("# Podcast Conversation\n\n")
        file.write("\n\n".join(formatted_transcript))

    print(f"Conversation extracted and saved to {output_file_path}")

# Specify the input JSON file and output Markdown file
json_file_path = f"{os.getenv('TRANSCRIPTION_JOB_NAME')}.json"
output_file_path = 'podcast_conversation.md'

# Extract the conversation
extract_conversation(json_file_path, output_file_path)
