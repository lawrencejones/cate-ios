#!/bin/bash
printf "Copying all class files to separate folders...\n"
for f in `ls *.h`
do
  folder=`echo $f | rev | cut -c 3- | rev`
  wild=`echo $folder.*`
  mkdir $folder
  mv $wild ./$folder/
done

echo Done!
