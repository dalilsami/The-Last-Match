#!/bin/bash
source turn.sh
source ia.sh
source player.sh

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
	echo -n '*'
    done
    echo '*'
    for (( i = 1; i <= nb_lines_array; i++ ))
    do
	allumettes_left=$((($nb_columns_array + 1) / 2 - ($i - 1)))
	allumettes_right=$((($nb_columns_array + 1) / 2 + ($i - 1)))

	echo -n '* '
	for (( j = 1; j <= nb_columns_array; j++ ))
	do
	    if [ "${game_grid[$i,$j]}" = "|" ]
	    then
		allumette=1
	    fi
	    echo -n "${game_grid[$i,$j]}"
	done
	echo " *"
    done
    for (( a = 1; a < nb_columns_array + 4; a++))
    do
	echo -n '*'
    done
    echo '*'
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


if [ "$(echo "$1" | egrep '^[0-9]+$')" ]
then
    if [ "$(echo "$1" | egrep '^[1-9][0]?$')" ] && [ "$1" -gt 1 ] && [ "$1" -le  10 ]
    then
	create_game $1
	turns $1
    else
	echo -e "Vous devez choisir le nombre de lignes entre 1 et 10 "
	exit 0
    fi
else
    exit 0
        fi
