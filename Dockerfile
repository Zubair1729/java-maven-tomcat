FROM tomcat:9.0-jdk17
COPY target/my-webapp.war /usr/local/tomcat/webapps/
EXPOSE 8080
