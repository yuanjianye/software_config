svn add `svn st|grep "^\?"|awk '{print $2}'`
svn del --force `svn st|grep "^[\!|\~]"|awk '{print $2}'`
echo "***************************************************************"
svn st|grep -v "^A"|grep -v "^D"|grep -v "^M"
