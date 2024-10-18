#!/bin/bash

students_file="student_names.txt"

if [ ! -f "$students_file" ]; then
    echo "Error: $students_file not found!"
    exit 1
fi

# Create attendance directory if it doesn't exist
mkdir -p attendance

current_date=$(date +%Y-%m-%d)
present_file="attendance/${current_date}_present.txt"
absent_file="attendance/${current_date}_absent.txt"

# Read students from the file into an array
IFS=',' read -r -a students <"$students_file"

# Function to speak the student's name using Festival
speak_student() {
    student_name="$1"
    echo "$student_name" | festival --tts  # Use Festival for TTS
}

# Loop through each student
for student in "${students[@]}"; do
    speak_student "$student"  # Speak the student's name

    echo "Mark attendance for $student: (a for absent, p for present, r to repeat)"
    while true; do
        read -n 1 -s choice  # Read a single character for attendance input
        case "$choice" in
            a)
                echo "$student" >>"$absent_file"  # Mark as absent
                echo "Marked $student as absent"
                break
                ;;
            p)
                echo "$student" >>"$present_file"  # Mark as present
                echo "Marked $student as present"
                break
                ;;
            r)
                echo "Repeating $student's name"
                speak_student "$student"  # Repeat the student's name
                ;;
            *)
                echo "Invalid option. Use 'a' for absent, 'p' for present, 'r' to repeat."
                ;;
        esac
    done
    echo ""
done

# Display attendance summary
echo "Attendance completed!"
echo -e "Present students: \n$(cat $present_file)\n"
echo "--------------------------"
echo -e "Absent students: \n$(cat $absent_file)"
