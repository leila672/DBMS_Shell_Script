#!/bin/bash
echo "Available DataBases"
ls -1 data/
read -p "Enter DataBase Name: " dbname
if [[ -d data/$dbname ]]; then
	select varuse in "create table" "drop table" "update table" "insert record" "Delete from table" "Select from table" "list tables" Exit
	do
		case $varuse in
			"create table" )	
				bash tableactions/createtable.sh $dbname
				;;
			"drop table" )
				bash tableactions/droptable.sh $dbname
				;;
			"update table" )  
				tableactions/updatetable.sh $dbname
				;;
			"insert record")
				tableactions/insert.sh $dbname
				;;
			"Delete from table" )  
					bash tableactions/deleterec.sh $dbname
				;;
			"Select from table" )
					bash tableactions/selectrec.sh $dbname
				;;
			"list tables" )
			      	bash tableactions/list_table.sh $dbname
				;;	  
			Exit )
		        exit
			;;			
			* ) echo "$REPLY is wrong choice , please choice again from menu";
				
				;;
		esac

	done
else
	echo "$dbname isn't a DataBase";
fi