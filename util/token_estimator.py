#!/usr/bin/env python3
import sys
from transformers import BertTokenizer

# Check if the filename argument was provided
if len(sys.argv) > 2:
    print("Usage: python tokenize_file.py [filename]")
    sys.exit(1)

# Load the BPE tokenizer
tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")

# Determine if the input is from a file or STDIN
if len(sys.argv) == 2:
    # Get the filename argument
    filename = sys.argv[1]

    # Read the contents of the file into a string
    with open(filename, "r") as f:
        input_contents = f.read()

    source = f"The file {filename}"
else:
    # Read the contents from STDIN into a string
    input_contents = sys.stdin.read()
    source = "The input"

# Tokenize the string using the BPE tokenizer
tokens = tokenizer.tokenize(input_contents)

# Count the number of tokens
num_tokens = len(tokens)

# Print the number of tokens
print(f"{source} contains {num_tokens} tokens.")

