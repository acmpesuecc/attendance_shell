#!/bin/bash

students_file="students.txt"

if [ ! -f "$students_file" ]; then
	echo "Error: $students_file not found!"
	exit 1
fi

current_date=$(date +%Y-%m-%d)
present_file="${current_date}_present.txt"
absent_file="${current_date}_absent.txt"

IFS=',' read -r -a students <"$students_file"

for student in "${students[@]}"; do
	espeak -v en+f1 -s 130 -p 50 -a 200 "$student"

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
			espeak "$student"
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
