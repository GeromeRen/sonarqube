FROM openjdk:nanoserver

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV SONARQUBE_JDBC_USERNAME ''
ENV SONARQUBE_JDBC_PASSWORD ''
ENV MS_AZURESQL_SERVER_NAME ''
ENV MS_AZURESQL_SERVER_PORT ''

RUN \
    setx /M SONARQUBE_VERSION '6.5'; \
    setx /M SONARQUBE_JDBC_USERNAME $SONARQUBE_JDBC_USERNAME; \
    setx /M SONARQUBE_JDBC_PASSWORD $SONARQUBE_JDBC_PASSWORD; \
    setx /M MS_AZURESQL_SERVER_NAME $MS_AZURESQL_SERVER_NAME; \
    setx /M MS_AZURESQL_SERVER_PORT $MS_AZURESQL_SERVER_PORT; \
    setx /M SONARQUBE_JDBC_URL='jdbc:sqlserver://%MS_AZURESQL_SERVER_NAME%:%MS_AZURESQL_SERVER_PORT%;database=sonar;user=%SONARQUBE_JDBC_USERNAME%;password=%SONARQUBE_JDBC_PASSWORD%;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30'; \
    setx /M SONARQUBE_HOME C:\\sonarqube

RUN powershell -command \ 

    Invoke-WebRequest "https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$env:SONARQUBE_VERSION.zip" -OutFile "sonarqube.zip"; \

    Expand-Archive -Path c:\sonarqube.zip -DestinationPath C:\ ; \

    Remove-Item sonarqube.zip ; \

    Rename-Item sonarqube-$env:SONARQUBE_VERSION sonarqube ; \

    Rename-Item c:\sonarqube\extensions c:\sonarqube\original_extensions ;

VOLUME c:\\sonarqube\\extentions

EXPOSE 9000

WORKDIR C:\\sonarqube

COPY sonarqube.cmd C:/sonarqube/bin/

ENTRYPOINT ["C:\\sonarqube\\bin\\sonarqube.cmd"]