# Author: Salma Elmalaki
# Date: June 21/2014
# selmalaki@ucla.edu 

# Get users contain location and power data
# This code works. The problem is that the power data doesn't match the android specs of status and plugged information which I need

# If you want to extract the location based users (users that have location information use these couple of lines -- written by Lucas Wanner)
#for p in `seq -w 1 30`; 
#	do while read u;
#		 do  scp -r "nesl@172.17.5.180:/media/ub/ubicomp_full_dataset/sepattr/$u/" $u; 
#		 done < ../loc_user_ind.txt;
#	 done



# Try to check the users which have the information in the required format
touch status_index
path='/home/salma/Work/DataSets/Extract_loc_based_users'  # Place where I put the transfered folder from the server // Change me. 
for p in `seq -w 400 600`; do
	numofuser=$(ls -l |  wc -l)
	if [ "$numofuser" -eq 35 ];then
		exit;
	fi
	userindex='00'$p;
	scp -r "nesl@172.17.5.180:/media/ub/ubicomp_full_dataset/sepattr/$userindex/" $path/$userindex;
	echo "Processing User "$userindex" ... "
	echo "................................"
	cd $path/$userindex
	wrongfield=0;
	for dir in */; do
		cd $dir
		pwd
		if [ -e "power.gz" ]; then
			echo '................... power is found ....................'
			echo 'Processing power file for required field ..............'
			gzip -d power.gz 
			echo 'power.gz is unzipped ... '
			line=$(grep status power)
			if [ $? -eq 1 ];then #no match
				echo 'no status field in '$dir' ...'
				wrongfield=1 
				break;
			else
				echo 'status is found ... '
				wrongfield=0
				#cd ../../
				#echo $userindex'/'$dir >> $path/status_index
				#numofuser=$(cat $path/status_index |  wc -l)
				cd $path/$userindex
				#if [ "$numofuser" -eq 100 ];then
				#	exit;
				#fi
			fi
		else
			echo 'power.gz not found in '$userindex' '$dir' ...'
			#cd ..
			cd $path/$userindex
			rm -r $dir
		fi 
		
	done

	if [ "$wrongfield" -eq "1" ];then
		#cd ../../
		cd $path
		rm -r $userindex			
        fi

done
