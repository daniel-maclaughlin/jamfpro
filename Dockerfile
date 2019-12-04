FROM tomcat:8.5.42-jdk11-openjdk-slim


ENV DATABASE_ROOT_USERNAME root
ENV DATABASE_ROOT_PASSWORD MySuperSecretPassword!
ENV DATABASE_NAME jamfpro
ENV DATABASE_USERNAME jamfprouser
ENV DATABASE_PASSWORD J@mf1234
ENV DATABASE_HOST localhost



RUN apt-get update -qq && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y jq curl unzip dirmngr && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	adduser --disabled-password --gecos '' tomcat && \
	rm -rf /usr/local/tomcat/webapps && \
	mkdir -p /usr/local/tomcat/webapps && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 5072E1F5 && \
	echo "deb http://repo.mysql.com/apt/debian stretch mysql-8.0" > /etc/apt/sources.list.d/mysql.list && \
	echo "mysql-community-server mysql-community-server/root-pass password $DATABASE_ROOT_PASSWORD" | debconf-set-selections && \
	echo "mysql-community-server mysql-community-server/re-root-pass password $DATABASE_ROOT_PASSWORD" | debconf-set-selections && \
	echo "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | debconf-set-selections && \
	apt-get update -qq && apt-get install -y mysql-server
	


COPY startup.sh /startup.sh
COPY log4j.stdout.replace /log4j.stdout.replace
COPY configuration.sh /configuration.sh

CMD ["/startup.sh"]

VOLUME /usr/local/tomcat/logs
  

EXPOSE 8080