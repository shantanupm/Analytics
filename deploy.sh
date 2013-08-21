#!/bin/sh
#set -x
#pid=`ps -ef | grep [j]ava | grep -v "grep java" | awk '{print $2}'`
 pid=`ps -aef | grep "tomcat"| awk '{print $2}'`
echo $pid

mvn clean package ;  

if [ "$pid" != "" ]; then
kill -9 $pid
echo "Tomcat process is killed"
fi

echo "deploying the new war"
rm -rf ~/apache-tomcat-7.0.35/webapps/scheduling_system;
rm -rf ~/apache-tomcat-7.0.35/webapps/scheduling_system.war;
cp ~/Documents/workspace-sts-3.1.0.RELEASE/analytics/lcs-scheduling-web/target/scheduling_system.war ~/apache-tomcat-7.0.35/webapps/scheduling_system.war;
sh ~/apache-tomcat-7.0.35/bin/catalina.sh jpda start
exit                                     


