# Author: Salma Elmalaki
# Date: June 21/2014
# selmalaki@ucla.edu 

# Description: Cleans the power data into level, plugged and status. Puts them in csv format.
# Uses: clean_data.py -- written by Paul Martin.


if [ ! -d "processed" ]; then
mkdir processed
fi
scriptPath=/home/salma/Work/DataSets/scripts  #Change me. It contains the clean_data.py script.
path=${PWD}

for d in */; do
	if [ -d $path/processed/$d ]; then continue; fi #skip already processed folder

	mkdir $path/processed/$d;
	cd $d;
	userindex=${PWD##*/};
	for dir in */; do
		cd $dir
		chunckindex=${PWD##*/};
		pwd
		if [ -e "power" ]; then
			outf="$userindex.$chunckindex.level"
			echo " Processing $outf ..."
			python $scriptPath/clean_data.py power level
                	if [ -e "power.cleaned.level" ]; then
				mv power.cleaned.level  $path/processed/$userindex/$outf 
			fi
			outf="$userindex.$chunckindex.plugged"
			echo " Processing $outf ..."
		 	python $scriptPath/clean_data.py power plugged
                	if [ -e "power.cleaned.plugged" ]; then
                		mv power.cleaned.plugged  $path/processed/$userindex/$outf
                	fi
			outf="$userindex.$chunckindex.status"
			echo " Processing $outf ..."
		 	python $scriptPath/clean_data.py power status
                	if [ -e "power.cleaned.status" ]; then
                		mv power.cleaned.status  $path/processed/$userindex/$outf
                	fi

		fi
		cd ..
	done	

	cd ..
done

rm -r $path/processed/processed
