player () {
    echo "Votre tour : "
    read -p 'Ligne : ' ligne
    read -p 'Allumettes : ' all
    if [ "$(echo "$ligne" | egrep '^[0-9]+$')" ] && [ "$(echo "$all" | egrep '^[0-9]+$')" ]
    then
	if [ "$(echo "$ligne" | egrep '^[1-9][0]?$')" ] && [ "$ligne" -ge 1 ] && [ "$ligne" -le  $1 ]
	then
	    if [ "$(echo "$all" | egrep '^[1-9][0-9]?$')" ] && [ "$all" -ge 1 ] && [ "$all" -le  $((2 * $ligne - 1)) ]
	    then
		count_sticks $1 $ligne
		if [ $all -le $all_in  ]
		then
		    del_sticks $1 $ligne $all
		    echo "Vous retirez $all allumette(s) sur la ligne $ligne"
		else
		    echo "Le nombre d'allumettes est trop grand"
		    player $1
		fi
	    else
		count_sticks $1 $ligne
		if [ $all_in -eq 0 ]
		then
		    echo "Cette ligne est vide"
		else
		    echo "Le nombre d'allumettes doit etre entre 1 et $all_in"
		fi
		player $1
	    fi
	else
	    echo "Il faut que la ligne soit entre 1 et $1 "
	    player $1
	fi
    else
	echo "Il faut que des nombres"
	player $1
    fi
}
