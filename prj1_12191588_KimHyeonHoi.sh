#!/bin/bash

echo "--------------------------
User Name : KimHyeonHoi
Student Number : 12191588
[ Menu ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item'
3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'
4. Delete the 'IMDb URL' from 'u.item'
5. Get the data about users from 'u.user'
6. Modify the format of 'release date' in 'u.item'
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"
while true 
do
	read -p "Enter your choice [ 1-9 ] " choiceNumber
		
	case $choiceNumber in
		[1-9])
		case $choiceNumber in
		1)
			printf "\n"
			read -p "Please enter 'movie id' (1~1682) : " index_num 
			printf "\n"
			cat u.item | awk -v idx=$index_num 'NR == idx{print $0}'	
			printf "\n"
			;;
		2)
			printf "\n"
			read -p "Do you want to get the data of 'action' genre moives from 'u.item'?(y/n) : " YesNo
			printf "\n"
			case $YesNo in
				'y') 
					cat u.item | awk -F\| '$7==1{print $1, $2}' | head -n 10
					printf "\n"
					;;
				'n')
					echo "try again"
					printf "\n"
					;;
					
			esac
			;;
		3) 
			printf "\n"
			read -p "Please enter the 'movie id' (1~1682) : " index_num
			printf "\n"
			printf "average rating of %s: "  "$index_num"
			cat u.data | awk -v idx=$index_num '$2==idx {rate += $3; line += ($2/$2); avg = rate/line} END {print avg}'
			printf "\n"
			;;
		4)
			printf "\n"
			read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n) : " YesNo
			case $YesNo in
				'y')
					printf "\n"
					cat u.item | sed -E 's/\h[^\)]*\)//g' | head -n 10
					printf "\n"
					;;
				'n')
					printf "\n"
					echo "try again"
					printf "\n"
					;;
			esac
			;;			
		5)
			printf "\n"
			read -p "Do you want to get the data about users from 'u.user'? (y/n) : " YesNo
			case $YesNo in
				'y')
					printf "\n"
					cat u.user | awk -F\| '{gender = ($3 == "M") ? "male" : "female"; printf "user %s is %s years old %s %s\n", $1, $2, gender, $4}' | head -n 10
					printf "\n"
					;;
				'n')
					printf "\n"
					echo "try again"
					printf "\n"
					;;
			esac
			;;
		6)
			printf "\n"
			read -p "Do you want to Modify the format of 'release data' in 'u.tiem'? (y/n) : " YesNo
			case $YesNo in
				'y')
					printf "\n"
					cat u.item | sed -E 's/([0-9]{2})-([A-Za-z]{3})-([0-9]{4})/\3\2\1/g' | sed -E 's/(Jan)/01/g; s/(Feb)/02/g; s/(Mar)/03/g; s/(Apr)/04/g; s/(May)/05/g; s/(Jun)/06/g; s/(Jul)/07/g; s/(Aug)/08/g; s/(Sep)/09/g; s/(Oct)/10/g; s/(Nov)/11/g; s/(Dec)/12/g;' | tail -n 10
					printf "\n"
					;;
				'n')
					printf "\n"
					echo "try again"
					printf "\n"
					;;
			esac
			;;
		7) 
			printf "\n"
			read -p "Please enter the 'user id' (1~943) : " userid
			printf "\n"
			awk -v user_id=$userid '$1==user_id {print $2}' u.data | sort -n > output.txt
			awk '{printf("%d|", $1)}' output.txt | sed 's/|$//'
			printf "\n"
			printf "\n"

			for i in {1..10}
			do
				movieid=$(awk -v i=$i 'NR==i {print $1}' output.txt)
				awk -F '|' -v movieid=$movieid '$1==movieid {printf("%d|%s\n", $1, $2)}' u.item
			done
			printf "\n"

			;;
		8) 
			printf "\n"
			read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n) : " YesNo
			printf "\n"
			
			case $YesNo in
				'y')
					awk -F '|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1}' u.user > output.txt
					awk 'NR == FNR { user_ids[$1] = 1; next }
					($1 in user_ids) { movie_ratings[$2] += $3; movie_counts[$2]++ }
					END {
					for (movie_id in movie_ratings){
						if(movie_counts[movie_id] >0){
							average_rating = movie_ratings[movie_id] / movie_counts[movie_id];
							printf("%d %.5f\n", movie_id, average_rating);
						}
					}
				}' output.txt u.data | sort -n
				printf "\n"
					;;
				'n')
					echo "try again"
					printf "\n"
					;;
			esac
			;;
		9)
			printf "\n"
			echo "Bye!"
			exit 0
			;;
	esac
	;;
*)
	printf "\nInput Error\n"
	printf "\n"
	;;

	esac
done







