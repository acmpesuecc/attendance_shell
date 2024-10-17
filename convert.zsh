#!/bin/zsh


# Ask the user to paste the full list of names (multiple lines)
echo "Paste the full list of names (one name per line), then press Enter and Ctrl+D when done:"

# Read the entire input at once and store it in a variable
names=$(</dev/stdin)

# Convert the pasted list into a comma-separated format
comma_separated=$(echo "$names" | tr '\n' ',' | sed 's/,$/\n/')

# Save the result to a file
output_file="students.txt"
echo "$comma_separated" > "$output_file"

echo "Conversion complete! The comma-separated names have been saved to $output_file"
