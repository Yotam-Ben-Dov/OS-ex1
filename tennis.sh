#!/bin/bash
#Yotam Ben Dov 316387950

# global variables
state=0
player_1=50
player_2=50
p1_num=0
p2_num=0
gameLogic()
{
	getInput
	calculateScores
	printBoard $state $player_1 $player_2
	echo -e "       Player 1 played: ${p1_num}\n       Player 2 played: ${p2_num}\n\n"
}

getInput()
{
        while :
        do
                echo "PLAYER 1 PICK A NUMBER: "
                read -s p1_num
                if [[ $p1_num =~ ^[0-9]+$ ]] && (( $player_1 >= $p1_num ))
                then
                        break
                else
                        echo "NOT A VALID MOVE !"
                fi
        done
        while :
        do
                echo "PLAYER 2 PICK A NUMBER: "
                read -s p2_num
                if [[ $p2_num =~ ^[0-9]+$ ]] && (( $player_2 >= $p2_num ))
                then
                        break
                else
                        echo "NOT A VALID MOVE !"
                fi
        done
}

calculateScores()
{
        let player_1=$player_1-$p1_num
        let player_2=$player_2-$p2_num
        if (( $p1_num > $p2_num ))
        then
                if (( $state < 0 ))
                then
                        state=1
                else
                        let state=$state+1
                fi
        fi
        if (( $p1_num < $p2_num ))
        then
                if (( $state > 0 ))
                then
                        state=-1
                else
                        let state=$state-1
                fi
        fi
}

determineWinner()
{
	if (( ${state#-} == 3 ))
	then
		if (( $state == 3 ))
		then
			echo "PLAYER 1 WINS !"
		else
			echo "PLAYER 2 WINS !"
		fi
	elif (( $player_1 == 0 )) && (( $player_2 > 0 ))
	then
		echo "PLAYER 2 WINS !"
	elif (( $player_2 == 0 )) && (( $player_1 > 0 ))
	then
		echo "PLAYER 1 WINS !"
	elif (( $state == 0 ))
	then
		echo "IT'S A DRAW !"
	else
		if (( $state > 0 ))
		then
			echo "PLAYER 1 WINS !"
		else
			echo "PLAYER 2 WINS !"
		fi
	fi
}
printBoard()
{
	echo " Player 1: $2         Player 2: $3 "
	echo " --------------------------------- "
	echo " |       |       #       |       | "
        echo " |       |       #       |       | "
	case "${1}" in
		"0")
			echo " |       |       O       |       | "
			;;
		"1")
			echo " |       |       #   O   |       | "
                        ;;
		"-1")
			echo " |       |   O   #       |       | "
			;;
		"2")
			echo " |       |       #       |   O   | "
                        ;;
		"-2")
			echo " |   O   |       #       |       | "
                        ;;
		"3")
			echo " |       |       #       |       |O"
                        ;;
		"-3")
			echo "O|       |       #       |       | "
                        ;;
		*)
			echo "problem, went to *"
			;;
	esac
	echo " |       |       #       |       | "
	echo " |       |       #       |       | "
	echo " --------------------------------- "
}

printBoard $state $player_1 $player_2
while (( ${state#-} < 3 )) && (( $player_1 > 0 )) && (( $player_2 > 0 ))
do
	gameLogic
done
determineWinner
