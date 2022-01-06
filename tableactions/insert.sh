#!/bin/bash
echo "Available tables in $1"
ls -1 data/$1
read -p "Enter table Name: " insertb
if [[ -f data/$1/$insertb ]]; then
	typeset -i nf=`awk -F: '{if(NR==1){print NF}}' data/$1/$insertb;`

    for (( i=1; i <= $nf; i++ ))
    do
        # inserting primary key 
        if testPK=`grep "%:" ./data/$1/$insertb | cut -d ":" -f$i | grep "%PK%" ` 
            then 
            fieldName=`grep "%:" ./data/$1/$insertb | cut -d ":" -f$i | cut -d "%" -f3 `
            fieldType=`grep "%:" ./data/$1/$insertb | cut -d ":" -f$i | cut -d "%" -f4 `
            echo "this is primary key it must be uniqe"
			flag=0;
	 	    while [[ $flag -eq 0 ]]; do
            read -p "enter ($fieldName) of type ($fieldType) : " value

            #check datatype
            if [[ $fieldType = "int" && "$value" = +([0-9]) || $fieldType = "string" && "$value" = +([a-zA-Z]) ]]; then

                # check pk validation 
                `cut -f$i -d: ./data/$1/$insertb | grep -w $value >> /dev/null 2>/dev/null`
            while [ $? == 0 ]
                do
                   echo "Violation of PK constraint"
                   echo "please enter a valid value"
                   read -p "enter ($fieldName) of type ($fieldType) : " value
                   cut -f$i -d: ./data/$1/$insertb  | grep -w $value >> /dev/null 2>/dev/null
                done

            # insert into table
		 	    if [[ $i != $nf ]]; then
		 	    	echo -n $value":" >> data/$1/$insertb;
		 	    else	
		 	    	echo $value >> data/$1/$insertb;
		 	    fi
				flag=1; 
			fi
			done	 
		 	
            ## inserting normal field
        else
            fieldName=`grep "%:" ./data/$1/$insertb | cut -d ":" -f$i | cut -d "%" -f1 `
            fieldType=`grep "%:" ./data/$1/$insertb | cut -d ":" -f$i | cut -d "%" -f2 `
			flag=0;
	 	    while [[ $flag -eq 0 ]]; do
            read -p "enter ($fieldName) of type ($fieldType) : " value 
            
            # check datatype
            if [[ $fieldType = "int" && "$value" = +([0-9]) || $fieldType = "string" && "$value" = +([a-zA-Z]) ]]; then
		 		if [[ $i != $nf ]]; then
		 			echo -n $value":" >> data/$1/$insertb;
		 		else	
		 			echo $value >> data/$1/$insertb;
		 		fi
				flag=1;
		 	fi
			done
        fi
    done

else
    echo "there is no such table"
fi             