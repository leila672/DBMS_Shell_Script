#!/bin/bash
select myvar in createDB renameDB dropDB  usedatabase listdatabase Exit
do
	case $myvar in
		createDB )	
			read -p "Enter DB Name: " dbname
			bash dbactions/createdb.sh $dbname
			;;
		renameDB )
			
			bash dbactions/renamedb.sh
			;;
		dropDB )  dbactions/dropdb.sh
			;;

		usedatabase )
				bash usedatabase.sh
			;;
		listdatabase )
		        ls -l ./data 
			;;
		Exit )
		        exit
			;;				
		* ) echo "$REPLY is wrong choice , please choice again from menu";
			
			;;
	esac

done