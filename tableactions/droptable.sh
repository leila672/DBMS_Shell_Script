#!/bin/bash
echo "Available tables in $1"
ls -1 data/$1
read -p "Enter table Name: " dropt
if [[ -f data/$1/$dropt ]]; then
	echo "Are you Sure You Want To drop $dropt table? y/n"
	read choice;
	case $choice in
		 [Yy]* ) 
			rm data/$1/$dropt
			echo "$dropt has been droped"
			;;
		 [Nn]* ) 
			echo "Operation Canceled"
			;;
		* ) 
			echo "Invalid Input 0 tables effected"
			;;
	esac
else
	echo "$dropt doesn't exist"
fi