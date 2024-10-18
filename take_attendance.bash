#!/bin/bash

students_file="student_names.txt"
audio_cache_dir="./student_audio_cache"

if [ ! -f "$students_file" ]; then
    echo "Error: $students_file not found!"
    exit 1
fi

# Create audio cache directory if it doesn't exist
mkdir -p "$audio_cache_dir"

current_date=$(date +%Y-%m-%d)
present_file="attendance/${current_date}_present.txt"
absent_file="attendance/${current_date}_absent.txt"

# Ensure attendance directory exists
mkdir -p "attendance"

IFS=',' read -r -a students < "$students_file"

generate_audio() {
    student_name="$1"
    audio_file="${audio_cache_dir}/${student_name// /_}.mp3"

    if [ ! -f "$audio_file" ]; then
        python3 - <<END
from gtts import gTTS
import os

tts = gTTS("$student_name", lang='en', tld='co.in')
tts.save("$audio_file")
END
        echo "Generated audio for $student_name"
    else
        echo "Using cached audio for $student_name"
    fi
}

speak_student() {
    student_name="$1"
    audio_file="${audio_cache_dir}/${student_name// /_}.mp3"
    mpg123 -q "$audio_file"
}

# Generate audio files for all students
for student in "${students[@]}"; do
    generate_audio "$student"
done

for student in "${students[@]}"; do
    speak_student "$student"

    echo "Mark attendance for $student: (a for absent, p for present, r to repeat)"
    while true; do
        read -n 1 -s choice
        case "$choice" in
            a)
                echo "$student" >> "$absent_file"
                echo "Marked $student as absent"
                break
                ;;
            p)
                echo "$student" >> "$present_file"
                echo "Marked $student as present"
                break
                ;;
            r)
                echo "Repeating $student's name"
                speak_student "$student"
                ;;
            *)
                echo "Invalid option. Use 'a' for absent, 'p' for present, 'r' to repeat."
                ;;
        esac
    done
    echo ""
done

echo "Attendance completed!"
echo -e "Present students: \n$(cat $present_file)\n"
echo "--------------------------"
echo -e "Absent students: \n$(cat $absent_file)"
