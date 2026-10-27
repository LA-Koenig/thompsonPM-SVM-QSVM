#!/bin/bash


singularity exec /home/shared/sif/csci-2025-Fall.sif conda run -n IonQ-qiskit112 ./QSVM.py $1 $2 $3
