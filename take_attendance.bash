#!/bin/bash

students_file="student_names.txt"

if [ ! -f "$students_file" ]; then
	echo "Error: $students_file not found!"
	exit 1
fi

current_date=$(date +%Y-%m-%d)
present_file="attendance/${current_date}_present.txt"
absent_file="attendance/${current_date}_absent.txt"

IFS=',' read -r -a students <"$students_file"

speak_student() {
	student_name="$1"
	python3 - <<END

from gtts import gTTS
import os

tts = gTTS("$student_name", lang='en', tld='co.in')
tts.save("./student_audio/$student_name.mp3")
END
	mpg123 ./student_audio/student.mp3 >/dev/null 2>&1
}

for student in "${students[@]}"; do
	speak_student "$student"

	echo "Mark attendance for $student: (a for absent, p for present, r to repeat)"
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
echo "Present students: $(cat $present_file)"
echo "Absent students: $(cat $absent_file)"
