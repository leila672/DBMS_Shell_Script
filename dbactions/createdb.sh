#!/bin/bash
# mkdir with the name sent to you mkdir $1
# first check if the directory exits or not

if [[ -d data/$1 ]]; then
		echo "The DataBase $1 Already Exists";
else
	mkdir  data/$1
	echo $1" Database Created Successfully" ;
fi

