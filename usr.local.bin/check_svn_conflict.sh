TMP_LANG=$LOCAL
LANG=C
BASE_VERSION=8
LOCAL_VERSION=`svn info|grep "Last Changed Rev"|awk -F : '{print $2}'|awk '{print $1}'`
SERVER_VERSION=$(svn info `svn info |grep "^URL"|awk '{print $2}'`|grep "Last Changed Rev"|awk -F : '{print $2}'|awk '{print $1}')
LANG=$TMP_LANG
echo $BASE_VERSION $LOCAL_VERSION $SERVER_VERSION
svn diff $1 --summarize -r "$BASE_VERSION:$LOCAL_VERSION" |sort >/tmp/local_svn_change.txt
svn diff $1 --summarize -r "$LOCAL_VERSION:$SERVER_VERSION" |sort >/tmp/server_svn_change.txt
svn st $1|sort >/tmp/svn_st.txt
echo "****************************************svn_st to local_svn_change.txt***********************************************"
grep -Fxf /tmp/local_svn_change.txt /tmp/svn_st.txt
echo "*********************************************************************************************************************"
echo ""
echo "****************************************svn_st to server_svn_change.txt**********************************************"
grep -Fxf /tmp/server_svn_change.txt /tmp/svn_st.txt
echo "*********************************************************************************************************************"
