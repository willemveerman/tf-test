ARG alpine_version=3.9

FROM alpine:${alpine_version}

ARG jre=8
ARG app_version=2.2.0
ARG uname=tomcat
ARG uid=998
ARG gid=998

LABEL application=spring-tomcat-${app_version}
LABEL base_os=alpine:${alpine_version}
LABEL jre_version=$jre

RUN apk --update add --no-cache openjdk${jre}-jre

RUN addgroup -g $gid $uname && \
	adduser -D -u $uid -G $uname $uname

WORKDIR /opt/spring-tomcat/

COPY harden.sh ./

RUN /bin/sh ./harden.sh

USER $uname

COPY spring-boot-sample-tomcat-${app_version}.BUILD-SNAPSHOT.jar ./tomcat.jar

CMD ["/usr/bin/java", "-jar", "tomcat.jar"]
