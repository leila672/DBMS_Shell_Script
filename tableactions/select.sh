#!/bin/bash
echo "Available tables in $1";
ls -1 data/$1;
read -p "Enter table Name: " seltb;

function tempfun 
{
        coloumnsNumber=`awk -F: 'NR==1 {print NF}' ./data/$1/$seltb`
        for (( i=1; i <= $coloumnsNumber; i++ ))
        do
            ## case pk
            if testPK=`grep "%:" ./data/$1/$seltb | cut -d ":" -f$i | grep "%PK%" ` 
            then
                coloumnsNames[$i]=`grep "%:" ./data/$1/$seltb | cut -d ":" -f$i | cut -d "%" -f3 `
            else
                coloumnsNames[$i]=`grep "%:" ./data/$1/$seltb | cut -d ":" -f$i | cut -d "%" -f1 `
            fi
        done
		
		for (( i=1; i <= $coloumnsNumber; i++ ))
        do
		if [[ $i != $coloumnsNumber ]]; then
                    echo -n ${coloumnsNames[i]}":" >> ./data/$1/.tmp;
			else
			        echo ${coloumnsNames[i]} >> ./data/$1/.tmp;
					
		fi
        done

    awk 'NR > 1 {for(i=1;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./data/$1/$seltb>> ./data/$1/.tmp;
}
echo "please select from select menu"
select choice in "Select all columns" "select specific columns" "Select Records Matching Word" Exit
do
	case $choice in
		 "Select all columns") 
		 tempfun $1
		 awk -F: '{print}' ./data/$1/.tmp
		 rm ./data/$1/.tmp
			;;
		"select specific columns")
		tempfun $1
			read -p "Enter Number of columns: " number;
			for (( i = 1; i <= number; i++ )); do
				read -p "Enter column $i: " colname;
				awk -F: '{if(NR==1){
					for(i=1 ;i <= NF; i++){
								if($i=="'$colname'"){
									var=i
							    break;
							}
						}
					} {print $var}
				}' ./data/$1/.tmp
			done

		rm ./data/$1/.tmp
			;;

		"Select Records Matching Word") 
		tempfun $1
			read -p "Enter value that you want to search : " value;
		    result=$(sed -n -e'/'$value'/p' ./data/$1/$seltb)
                if [[ -z $result ]]
                then
                  echo "Not Found"
                else
			      echo $result 
                fi

		rm ./data/$1/.tmp
			;; 

		Exit )
		    exit
			;;		
		
	esac
	
done



