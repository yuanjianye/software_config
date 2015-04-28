#!/bin/bash
A1=0x`echo $1|awk -F : '{print $1}'`
A2=0x`echo $1|awk -F : '{print $2}'`
A3=0x`echo $1|awk -F : '{print $3}'`
A4=0x`echo $1|awk -F : '{print $4}'`
A5=0x`echo $1|awk -F : '{print $5}'`
A6=0x`echo $1|awk -F : '{print $6}'`
COUNT=0
for ((M1=A1;M1<=0xFF;M1++))
do
for ((M2=A2;M2<=0xFF;M2++))
do
for ((M3=A3;M3<=0xFF;M3++))
do
for ((M4=A4;M4<=0xFF;M4++))
do
for ((M5=A5;M5<=0xFF;M5++))
do
for ((M6=A6;M6<=0xFF;M6++))
do
#echo $M1:$M2:$M3:$M4:$M5:$M6
    printf "%02X:%02X:%02X:%02X:%02X:%02X\n" $M1 $M2 $M3 $M4 $M5 $M6
let "COUNT++"
if [ $COUNT == $2 ];
then
exit 0
fi
done
A6=0
done
A5=0
done
A4=0
done
A3=0
done
A2=0
done

