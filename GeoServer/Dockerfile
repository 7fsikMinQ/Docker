# 베이스 이미지 설정
FROM openjdk:11-jre

# 환경 변수 설정
ENV GEOSERVER_HOME=/usr/local/geoserver \
    GEOSERVER_ZIP=geoserver-2.26.0-bin.zip   \
    BAKCUP_PLUGIN=geoserver-2.26-SNAPSHOT-backup-restore-plugin.zip
    


# 로컬에 있는 GeoServer zip 파일을 이미지에 복사
COPY geoserver-2.26.0-bin.zip /tmp/
COPY web.xml /tmp/
COPY $BAKCUP_PLUGIN /tmp/


# GeoServer 설치
RUN mkdir -p $GEOSERVER_HOME && \
    unzip /tmp/$GEOSERVER_ZIP -d $GEOSERVER_HOME && \
    cp /tmp/web.xml $GEOSERVER_HOME/webapps/geoserver/WEB-INF/web.xml && \
    unzip -o /tmp/$BAKCUP_PLUGIN -d $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib && \
    rm /tmp/$GEOSERVER_ZIP && \
    rm /tmp/$BAKCUP_PLUGIN && \
    rm /tmp/web.xml


# 포트 설정
EXPOSE 8080

# GeoServer 실행
CMD ["sh", "-c", "$GEOSERVER_HOME/bin/startup.sh"]