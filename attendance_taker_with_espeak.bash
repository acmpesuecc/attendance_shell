#!/bin/bash

# Path to the student list file
students_file="students.txt"

# Check if students file exists
if [ ! -f "$students_file" ]; then
    echo "Error: $students_file not found!"
    exit 1
fi

# Get current date to mark attendance
current_date=$(date +%Y-%m-%d)
present_file="${current_date}_present.txt"
absent_file="${current_date}_absent.txt"

# Read students into an array from the CSV file
IFS=',' read -r -a students <"$students_file"

# Loop through each student and mark attendance
for student in "${students[@]}"; do
    # Use Festival or flite for text-to-speech instead of espeak
    echo "$student" | festival --tts  # For Festival
    # Or, alternatively: echo "$student" | flite -t - -voice awb  # For flite with specific voice

    echo "Mark attendance for $student: (a for absent, p for present, r to repeat)"
    
    # Attendance input loop
    while true; do
        read -n 1 -s choice
        case "$choice" in
        a)
            echo "$student" >>"$absent_file"
            echo "Marked $student as absent"
            break
            ;;
        p)
            echo "$student" >>"$present_file"
            echo "Marked $student as present"
            break
            ;;
        r)
            echo "Repeating $student's name"
            echo "$student" | festival --tts  # Repeat name with Festival
            ;;
        *)
            echo "Invalid option. Use 'a' for absent, 'p' for present, 'r' to repeat."
            ;;
        esac
    done
    echo ""
done

# Summary of attendance
echo "Attendance completed!"
echo "Present students: $(cat $present_file)"
echo "Absent students: $(cat $absent_file)"
