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
