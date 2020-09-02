#!/bin/sh

while [ 1 ];do
OUTPUT=$(./get_grade.sh gpatingr Libft)
SUCCESS=$(echo "$OUTPUT" | grep "success")
FAIL=$(echo "$OUTPUT" | grep "fail")

if [ "$SUCCESS" = "success" ]
then termux-vibrate
termux-tts-speak "BRAVO GPATINGR TU AS VALIDE TA LIBFT"
fi

if [ "$FAIL" = "fail" ]
then termux-vibrate
termux-tts-speak "BRAVO GPATINGR TU AS RATE TA LIBFT"
fi

done
