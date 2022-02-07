#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following complex command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=`mvn help:evaluate -Dexpression=project.name | grep "^[^\[]"`
set +x

echo 'The following complex command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=`mvn help:evaluate -Dexpression=project.version | grep "^[^\[]"`
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x

scp -r -i /home/ubuntu/Jenkins.pem  /home/ubuntu/workspace/spring-boot-example_prod/target/${NAME}-${VERSION}.jar ubuntu@172.31.5.132:/home/ubuntu/
ssh -i /home/ubuntu/Jenkins.pem ubuntu@172.31.5.132 '/usr/local/bin/hello.sh start'
#ssh -i /home/ubuntu/Jenkins.pem ubuntu@172.31.5.132 'kill -9 $(lsof -t -i:8081)'
#ssh -i /home/ubuntu/Jenkins.pem ubuntu@172.31.5.132 'java -Dserver.port=8081 -jar /home/ubuntu/*.jar &'

#ssh -i /home/ubuntu/Jenkins.pem ubuntu@172.31.5.132 'curl http://13.233.201.176:8081'
