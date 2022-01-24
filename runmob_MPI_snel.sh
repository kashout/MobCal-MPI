#!/bin/sh
 ls *.mfj > mobfit.in 
 input="mobfit.in"
 suffix=".mfj"
 cnt=0
 one=1
 while IFS= read -r var
 do
  inp=${var%$suffix}
  echo "$inp" > temp.in
  tail -n +2 $var >> temp.in
  cp temp.in $var
  rm temp.in
  echo "$inp.mfj" > mobcal.run
  echo "$inp.mout" >> mobcal.run
  mobinp="mobcal.run_$cnt"
  cp mobcal.run $mobinp
  runfile="runit_$cnt"
  echo "#!/bin/bash" > $runfile
  echo "#SBATCH -t 01:00:00" >> $runfile
  echo "#SBATCH -n 32" >> $runfile
  echo "#SBATCH -p thin" >> $runfile
  echo "#SBATCH --output ${inp}-slurm-%j.out" >> $runfile
  echo " echo Start:" >> $runfile
  echo " date" >> $runfile
  echo " module purge" >> $runfile
  echo " module load 2021" >> $runfile
  echo " module load intel/2021a" >> $runfile
  echo " srun ~/bin/MobCal-MPI/test_intel_Ofast/MobCal_MPI_intel_Ofast.exe $mobinp" >> $runfile
  echo " echo End:" >> $runfile
  echo " date" >> $runfile
  sbatch $runfile
  sleep 0.5s
  cnt=$(($cnt+$one))
 done < "$input"

