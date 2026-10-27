#!/bin/bash


base=$(pwd)

#make $1 be the directory from the cluster
cd $1

for bal in 'True' 'False'
do
	for comps in '4' '8'
	do
		for percent in '0.1' '0.25' '0.5' '0.75' '1'
		do
			fileName="${bal}_${comps}_${percent}"
            	
			outFile="${fileName}_costs.txt"
            # Clear or create the output file
            > "$outFile"
            		for f in ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out
            		do 
                		grep "Cost:" "$f" | cut -f4 -d' ' | paste -s -d ' ' >> "$outFile"
            		done
			
			outFile="${fileName}_MCC.txt"
            # Clear or create the output file
            > "$outFile"
            		for f in ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out
            		do 
                		grep "MCC:" "$f" | cut -f6 -d' ' | paste -s -d ' ' >> "$outFile"
            		done
			
			outFile="${fileName}_Savings.txt"
            # Clear or create the output file
            > "$outFile"
            		for f in ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out
            		do 
                		grep "Cost:" "$f" | cut -f8 -d' ' | paste -s -d ' ' >> "$outFile"
            		done
                    
            outFile="${fileName}_QCM_val.txt"
            > "$outFile"
                for f in ./bal_"$bal"/"$comps"/"$percent"/slurm*.out
                do
                      grep -A 1 "Quantum confusion matrix val:" "$f" | grep -o '[0-9.]\+' | tr '\n' ' ' >> "$outFile"
                      echo >> "$outFile"
                done
                
            outFile="${fileName}_QCM_train.txt"
            > "$outFile"
                for f in ./bal_"$bal"/"$comps"/"$percent"/slurm*.out
                do
                      grep -A 1 "Quantum confusion matrix train:" "$f" | grep -o '[0-9.]\+' | tr '\n' ' ' >> "$outFile"
                      echo >> "$outFile"
                done

            outFile="${fileName}_CCM_val.txt"
            > "$outFile"
                for f in ./bal_"$bal"/"$comps"/"$percent"/slurm*.out
                do
                      grep -A 1 "Classical confusion matrix val:" "$f" | grep -o '[0-9.]\+' | tr '\n' ' ' >> "$outFile"
                      echo >> "$outFile"
                done
                
            outFile="${fileName}_CCM_train.txt"
            > "$outFile"
                for f in ./bal_"$bal"/"$comps"/"$percent"/slurm*.out
                do
                      grep -A 1 "Classical confusion matrix train:" "$f" | grep -o '[0-9.]\+' | tr '\n' ' ' >> "$outFile"
                      echo >> "$outFile"
                done

            outFile="${fileName}_savings_summary.txt"
            > "$outFile"
                for f in ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out
                do
                    grep '^savings_' "$f" | awk -F= '{print $2+0}' | paste -s -d ' ' >> "$outFile"
                done

            outFile="${fileName}_MCC_scores.txt"
            > "$outFile"
            for f in ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out
            do
                q_train=$(grep "Quantum SVM Train MCC:" "$f" | awk '{print $5}')
                q_val=$(grep "Quantum SVM Val MCC:" "$f" | awk '{print $5}')
                c_train=$(grep "Classical SVM Train MCC:" "$f" | awk '{print $5}')
                c_val=$(grep "Classical SVM Val MCC:" "$f" | awk '{print $5}')
                echo "$q_train $q_val $c_train $c_val" >> "$outFile"
            done

            # Validation Training Curve mcc
            outFile="${fileName}_val_TC_mcc.txt"
            grep "Validation Training Curve mcc:" ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out | cut -f5- -d" " > "$outFile"

            # Validation Training Curve savings
            outFile="${fileName}_val_TC_savings.txt"
            grep "Validation Training Curve savings:" ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out | cut -f5- -d" " > "$outFile"

            # Train_Pred Training Curve mcc
            outFile="${fileName}_train_pred_TC_mcc.txt"
            grep "Train_Pred Training Curve mcc:" ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out | cut -f5- -d" " > "$outFile"

            # Train_Pred Training Curve savings
            outFile="${fileName}_train_pred_TC_savings.txt"
            grep "Train_Pred Training Curve savings:" ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out | cut -f5- -d" " > "$outFile"

            # Classical Training Curve mcc
            outFile="${fileName}_classical_TC_mcc.txt"
            grep "Classical Training Curve mcc:" ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out | cut -f5- -d" " > "$outFile"

            # Classical Training Curve savings
            outFile="${fileName}_classical_TC_savings.txt"
            grep "Classical Training Curve savings:" ./bal_"$bal"/"$comps"/"$percent"/slurm-*.out | cut -f5- -d" " > "$outFile"
            
        done
	done
done
