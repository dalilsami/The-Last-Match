#!/bin/bash

declare -A game_grid
continue=1

create_game () {
    nb_lines_array=$1
    nb_columns_array=2*$nb_lines_array-1
    for (( i = 1; i <= nb_lines_array; i++ ))
    do
	allumettes_left=$((($nb_columns_array + 1) / 2 - ($i - 1)))
	allumettes_right=$((($nb_columns_array + 1) / 2 + ($i - 1)))

	for (( j = 1; j <= nb_columns_array; j++ ))
	do
	    game_grid[$i,$j]=' '
	    if [ $j -ge $allumettes_left ] && [ $j -le $allumettes_right ]
	    then
		game_grid[$i,$j]='|'
	    fi
	done
    done
}

display_game () {
    nb_lines_array=$1
    nb_columns_array=2*$nb_lines_array-1
    allumette=0
    for (( a = 1; a < nb_columns_array + 4; a++))
    do
	echo -e -n "\033[1;33m*\033[1;33m"
    done
    echo -e  "\033[1;33m*\033[1;33m"
    for (( i = 1; i <= nb_lines_array; i++ ))
    do
	allumettes_left=$((($nb_columns_array + 1) / 2 - ($i - 1)))
	allumettes_right=$((($nb_columns_array + 1) / 2 + ($i - 1)))

	echo -n "* "
	for (( j = 1; j <= nb_columns_array; j++ ))
	do
	    if [ "${game_grid[$i,$j]}" = "|" ]
	    then
		allumette=1
	    fi
	    echo -e -n "\033[31m"${game_grid[$i,$j]}"\033[0m"
	done
	echo -e "\033[1;33m *\033[1;33m"
    done
    for (( a = 1; a < nb_columns_array + 4; a++))
    do
	echo  -n '*'
    done
    echo  -n "*"
    if [ $allumette -eq 0 ]
    then
	continue=0
    fi
}

count_sticks () {
    all_max=$((2 * $1 - 1))
    all_in=0
    for (( i=all_max; i > 0; i-- ))
    do
	if [ "${game_grid[$2,$i]}" = "|" ]
	then
	    all_in=`expr $all_in + 1`
	fi
    done
}

del_sticks () {
    i=$((2 * $1 - 1))
    
    while [ "${game_grid[$2,$i]}" != "|" ]
    do
	i=`expr $i - 1`
    done
    end=$(($i - $3 + 1))
    while [ $i -ge $end ]
    do
	game_grid[$2,$i]=" "
	i=`expr $i - 1`
    done
}

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
		    echo "Le nombre d'allumettes doit être entre 1 et $all_in"
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

ia () {
    ligne=$(( (RANDOM % $1) + 1 ))

    count_sticks $1 $ligne
    if [ $all_in -ne 0 ]
    then
	all=$(( (RANDOM % $((2 * $ligne - 1))) + 1 ))
	if [ $all -le $all_in ]
	then
	    del_sticks $1 $ligne $all
	    echo "L'IA retire $all allumette(s) sur la ligne $ligne"
	else
	    ia $1
	fi
    else
	ia $1
    fi
}

turns_hi () {
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

turns_hh () {
    while [ $continue -eq 1 ]
    do
	display_game $1
	echo ""
	if [ $continue -eq 0 ]
	then
	    echo "Le joueur 1 a gagné, bravo !"
	    quit $1
	fi
	echo "Au tour du joueur 1..."
	player $1
	display_game $1
	echo ""
	if [ $continue -eq 0 ]
	then
	    echo "Le joueur 2 a gagné, bravo !"
	    quit $1
	fi
	echo "Au tour du joueur 2..."
	player $1
    done
}

quit () {
    read -p 'Voulez-vous recommencer ? (oui ou non) ' again
    if [ $again = 'oui' || $again = 'o' ]
    then
	create_game $1
	turns_hh $1
    elif [ $again = 'non' | $again = 'n' ]
    then
	exit 0
    else
	quit $1
    fi
}
	

if [ "$(echo "$1" | egrep '^[0-9]+$')" ]
then
    if [ "$(echo "$1" | egrep '^[1-9][0]?$')" ] && [ "$1" -gt 1 ] && [ "$1" -le  10 ]
    then
	create_game $1
	if [ -n "$2" ]
	then
	    if [ $2 = "-m" ]
	    then
		echo -e "Match Stick Human VS Human\n"
		turns_hh $1
	    else
		echo -e "Match Stick Human VS IA\n"
		turns_hi $1
	    fi
	else
	    echo -e "Match Stick Human VS IA\n"
	    turns_hi $1
	fi
    else
	exit 0
    fi
else
    exit 0
fi
