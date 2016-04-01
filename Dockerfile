FROM java:7

MAINTAINER Cristhian Lopez calovi86@gmail.com

# Init ENV
ENV BISERVER_VERSION 6.0
ENV BISERVER_TAG 6.0.1.0-386

ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV PENTAHO_JAVA_HOME $JAVA_HOME

RUN apt-get update && \
	apt-get install unzip -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download Pentaho BI Server
RUN curl -j -k -L "https://sourceforge.net/projects/pentaho/files/Business%20Intelligence%20Server/${BISERVER_VERSION}/biserver-ce-${BISERVER_TAG}.zip/download" -o /tmp/biserver-ce-${BISERVER_TAG}.zip \
    && unzip -q /tmp/biserver-ce-${BISERVER_TAG}.zip -d $PENTAHO_HOME
RUN rm -f /tmp/biserver-ce-${BISERVER_TAG}.zip
RUN sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/biserver-ce/tomcat/bin/startup.sh && \
    chmod +x $PENTAHO_HOME/biserver-ce/start-pentaho.sh

RUN curl -j -k -L "https://sourceforge.net/projects/jtds/files/jtds/1.3.1/jtds-1.3.1-dist.zip/download" -o /tmp/jtds-1.3.1-dist.zip
RUN unzip -q /tmp/jtds-1.3.1-dist.zip -d /tmp/jtds-1.3.1-dist/ && rm -f /tmp/jtds-1.3.1-dist.zip
RUN cp /tmp/jtds-1.3.1-dist/jtds-1.3.1.jar $PENTAHO_HOME/biserver-ce/tomcat/lib/

ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

EXPOSE 8080 

WORKDIR $PENTAHO_HOME/biserver-ce/

RUN chmod +x $PENTAHO_HOME/biserver-ce/start-pentaho.sh
RUN cat start-pentaho.sh

CMD ["/opt/pentaho/biserver-ce/start-pentaho.sh"]