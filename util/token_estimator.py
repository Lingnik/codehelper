import sys
from transformers import BertTokenizer

# Check if the filename argument was provided
if len(sys.argv) != 2:
    print("Usage: python tokenize_file.py <filename>")
    sys.exit(1)

# Get the filename argument
filename = sys.argv[1]

# Load the BPE tokenizer
tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")

# Read the contents of the file into a string
with open(filename, "r") as f:
    file_contents = f.read()

# Tokenize the string using the BPE tokenizer
tokens = tokenizer.tokenize(file_contents)

# Count the number of tokens
num_tokens = len(tokens)

# Print the number of tokens
print(f"The file {filename} contains {num_tokens} tokens.")
