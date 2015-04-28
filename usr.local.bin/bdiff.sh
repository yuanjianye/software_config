FILENAME=`path_trans "$1"|awk -F amlogic_sync  '{print $2}'`
echo $FILENAME
diff -Nur /home/work/0615_amlogic$FILENAME /home/jinglun/m201/$FILENAME
