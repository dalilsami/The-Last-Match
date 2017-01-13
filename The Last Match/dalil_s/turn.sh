turns () {
    while [ $continue -eq 1 ]
    do
	display_game $1
	echo ""
	if [ $continue -eq 0 ]
	then
	    echo "Zut ! J'ai perdu..."
	    exit 1
	fi
	player $1
	display_game $1
	echo ""
	if [ $continue -eq 0 ]
	then
	    echo "Maintenant vous pouvez voir mon réel pouvoir ! Looser"
	    exit 2
	fi
	echo "Tour de l'IA..."
	sleep 1
	ia $1
    done
    }
