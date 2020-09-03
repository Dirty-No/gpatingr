#!/bin/bash


SLEEP_TIME=$(echo "0$3" | sed 's|[^0-9]||g')
LINK="https://profile.intra.42.fr/users/$1"
INTRA_PAGE=$(curl $LINK \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'   \
	--cookie cookies.txt \
	--compressed 2> /dev/null)

PROJECT="$2</a>"

PROJECT_LINK=$(echo "$INTRA_PAGE" | grep "$PROJECT" | grep -o '".*"' | tr -d '"')

#PROJECT_PAGE=$(curl $PROJECT_LINK \
#    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'   \
#    --cookie cookies.txt \
#    --compressed 2> /dev/null)

while [ 1 ];do

	NEW_PAGE=$(curl $PROJECT_LINK \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'   \
		--cookie cookies.txt \
		--compressed 2> /dev/null)

	if [ "$PROJECT_PAGE" != "$NEW_PAGE" ];
	then

		OUTPUT=$(echo "$NEW_PAGE" | sed -n '/data-status/,$p' | sed '/project-summary-item/,$d' | sed 's/<[^<>]*>//g' | sed -r '/^\s*$/d')
		SUCCESS=$(echo "$OUTPUT" | grep "success")
		FAIL=$(echo "$OUTPUT" | grep "fail")
		GRADE=$(echo "$OUTPUT" | tail -1)

		if [ "$SUCCESS" = "success" ]
		then 
			while [ 1 ]; do
				termux-vibrate
				termux-tts-speak -l fr "BRAVO $1 TU A VALIDÉ $2 AVEC UNE NOTE DE $GRADE sur 100"
			done
		fi

		if [ "$FAIL" = "fail" ]
		then 
			while [ 1 ]; do
				termux-vibrate
				termux-tts-speak -l fr "BRAVO $1 TU A RATÉ $2 AVEC UNE NOTE DE $GRADE sur 100"
			done
		fi

	fi
	sleep "$SLEEP_TIME"
done
