function checkInt {
    expr $1 + 1 2> /dev/null >> /dev/null
}

#######################################

echo "avilable tables are : "
ls ./data/$1
read -p "please enter table name : " tableName

if [ -a ./data/$1/$tableName ]
    then
    coloumnsNumber=`awk -F: 'NR==1 {print NF}' ./data/$1/$tableName`
        for (( i=1; i <= $coloumnsNumber; i++ ))
        do
            #######################    
            ## this if condition because cut in case of pk is different
            if testPK=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | grep "%PK%" ` 
            then
                coloumnsNames[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f3 `
                coloumnsTypes[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f4 `
            else
                coloumnsNames[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f1 `
                coloumnsTypes[$i]=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$i | cut -d "%" -f2 `
            fi
        done
        
        echo "table columns are : "
        for (( i=1; i <= $coloumnsNumber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done
     
        ## get index of the coloumn he wanted to update
        read -p "enter number of coloumn you want to update : " coloumnIndex 
        checkInt $coloumnIndex
        while [[ $? -ne 0 || $coloumnIndex -le 0 || $coloumnIndex -gt $coloumnsNumber ]]
        do
            echo "please enter a valid value"
            read -p "enter number of coloumn you want to update : " coloumnIndex 
            checkInt $coloumnIndex
        done 

        ## check data type of new value
        read -p "Enter a new value of type (${coloumnsTypes[coloumnIndex]}) : " newValue;
        if [ ${coloumnsTypes[coloumnIndex]} == "int" ]
            then
            checkInt $newValue
            while [ $? != 0 ]
            do
                echo "please enter a valid value"
                read -p "enter (${coloumnsNames[coloumnIndex]}) of type (${coloumnsTypes[coloumnIndex]}) : " newValue
                checkInt $newValue
            done
        fi
        ## check if he update pk

        if testPK=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then
           `cut -f$coloumnIndex -d: ./data/$1/$tableName | grep -w $newValue  >> /dev/null 2>/dev/null`
            while [ $? != 1 ]
            do
                echo "Violation of PK constraint"
                echo "please enter a valid value"
                read -p "enter (${coloumnsNames[coloumnIndex]}) of type (${coloumnsTypes[coloumnIndex]}) : " newValue
                `cut -f$coloumnIndex -d: ./data/$1/$tableName | grep -w $newValue >> /dev/null 2>/dev/null` 
            done
        fi
        ## read condition   
        for (( i=1; i <= $coloumnsNumber; i++ ))
        do
            echo $i"-" ${coloumnsNames[i]} "("${coloumnsTypes[i]}")"
        done

        ## check if condition index is a number 
        read -p "condition on which coloumn number : " conditionIndex 
        checkInt $conditionIndex
        while [[ $? -ne 0 || $conditionIndex -le 0 || $conditionIndex -gt $coloumnsNumber ]]
        do
            echo "please enter a valid value"
            read -p "condition on which coloumn number : " conditionIndex 
            checkInt $conditionIndex
        done 

        ## check data type of condition value
        read -p "Enter a condtion value of type (${coloumnsTypes[conditionIndex]}) : " conditionValue;
        if [ ${coloumnsTypes[conditionIndex]} == "int" ]
            then
            checkInt $conditionValue
            while [ $? != 0 ]
            do
                echo "please enter a valid value"
                read -p "enter (${coloumnsNames[conditionIndex]}) of type (${coloumnsTypes[conditionIndex]}) : " conditionValue
                checkInt $conditionValue
            done
        fi

        ## to update table 
        awk -F:  '( NR!=1 && $"'$conditionIndex'"=="'$conditionValue'" ) {$"'$coloumnIndex'"="'$newValue'"} {for(i=1 ;i<=NF ;i++ ) { if (i==NF) print $i; else printf "%s",$i":"}}' ./data/$1/$tableName > ./.tmp;
        

        ## to avoid update if it violate pk
        if testPK=`grep "%:" ./data/$1/$tableName | cut -d ":" -f$coloumnIndex | grep "%PK%" ` 
        then 
            x=`cat ./.tmp | cut -f$coloumnIndex -d:| grep -w $newValue|wc -l | cut -f1 -d:`
            echo $x
            if [ $x -gt 1 ]
            then
                echo "update fail due to PK constraint violation"
                 rm ./.tmp;
            fi   
        fi
        
        if [ -a ./.tmp ]
        then
            cat ./.tmp > ./data/$1/$tableName;
             rm ./.tmp;
            echo "update successfull"
        fi

else
    echo "there is no such table"
fi