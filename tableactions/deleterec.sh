#!/bin/bash

echo "Available tables in $1"
ls data/$1
read -p "Enter table Name: " tableName


if [ -f ./data/$1/$tableName ]
    then
    coloumnsNumber=`awk -F: 'NR==1 {print NF}' ./data/$1/$tableName`
        for (( i=1; i <= $coloumnsNumber; i++ ))
        do
            #if cut in case of pk 
            if testPK=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | grep "%PK%" ` 
            then
                coloumnsNames[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
                coloumnsTypes[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f4 `
            else
                coloumnsNames[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
                coloumnsTypes[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f2 `
            fi
        done
    
        # read condition   
        for (( i=1; i <= $coloumnsNumber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done

        # check if condition index is a number 
        read -p "condition on which coloumn number : " conditionIndex 
         expr $conditionIndex + 1 2> /dev/null >> /dev/null
        while [[ $? -ne 0 || $conditionIndex -le 0 || $conditionIndex -gt $coloumnsNumber ]]
        do
            echo "please enter a valid value"
            read -p "condition on which coloumn number : " conditionIndex 
         expr $conditionIndex + 1 2> /dev/null >> /dev/null
        done 

        # check data type of condition value
        read -p "Enter a condition value of type (${coloumnsTypes[conditionIndex]}) : " conditionValue;
        if [ ${coloumnsTypes[conditionIndex]} == "int" ]
            then
         expr $conditionIndex + 1 2> /dev/null >> /dev/null
            while [ $? != 0 ]
            do
                echo "please enter a valid value"
                read -p "enter (${coloumnsNames[conditionIndex]}) of type (${coloumnsTypes[conditionIndex]}) : " conditionValue
                expr $conditionIndex + 1 2> /dev/null >> /dev/null
            done
        fi

        #delete from table
        awk -F:  ' $"'$conditionIndex'"!="'$conditionValue'" {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./data/$1/$tableName > ./.tmp;
        if [ -a ./.tmp ]
        then
            cat ./.tmp > ./data/$1/$tableName;
            rm ./.tmp;
            echo "Deleted successfully"
        fi

else
    echo "there is no such table"
fi