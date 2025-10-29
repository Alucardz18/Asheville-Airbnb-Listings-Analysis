import re

# Input and output file paths
input_file = "Listing-Analysis-Clean1.csv"
output_file = "Listing-Analysis-Clean2.csv"

# Regular expression to remove non-printable characters and emojis
pattern = re.compile(r'[^\x09\x0A\x0D\x20-\x7E]')

with open(input_file, "r", encoding="utf-8", errors="ignore") as infile, \
     open(output_file, "w", encoding="utf-8") as outfile:
    for line in infile:
        clean_line = pattern.sub("", line)  # remove unwanted characters
        outfile.write(clean_line)

print("✅ Cleaned file saved as:", output_file)

