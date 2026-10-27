#!/bin/bash

# $1 is the number of times to run each program

base=$(pwd)

today=$(date +'%Y%m%d')
mkdir Thompson_QSVM_results_$today
cd Thompson_QSVM_results_$today

for bal in 'True' 'False'
do
	mkdir ./bal_$bal
	cd ./bal_$bal

	for comps in '4' '8'
	do
		mkdir ./$comps
		cd ./$comps

		for percent in '0.1' '0.25' '0.5' '0.75' '1'
		do
			mkdir ./$percent
			cd ./$percent

			# need to do some file linking here
			ln -s $base/QSVM.py ./QSVM.py
			ln -s $base/QSVM-single.sh ./QSVM-single.sh
			ln -s $base/Data ./Data
			

			for ((x=0; x<$1; x++))
			do
				sbatch --time=06:00:00 -n 2 -p research-cpu ./QSVM-single.sh $bal $comps $percent
			done

			cd ..
		done

		cd ..
	done

	cd ..
done


