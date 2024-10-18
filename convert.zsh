#!/bin/zsh


echo "Paste the full list of names (one name per line), then press Enter and Ctrl+D when done:"

names=$(</dev/stdin)


comma_separated=$(echo "$names" | tr '\n' ',' | sed 's/,$/\n/')

output_file="student_names.txt"
echo "$comma_separated" > "$output_file"

echo "Conversion complete! The comma-separated names have been saved to $output_file"
