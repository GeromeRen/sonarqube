FROM openjdk:nanoserver

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV SONARQUBE_JDBC_USERNAME ''
ENV SONARQUBE_JDBC_PASSWORD ''
ENV MS_AZURESQL_SERVER_NAME ''
ENV MS_AZURESQL_SERVER_PORT ''

RUN \
    setx /M SONARQUBE_VERSION '6.5'; \
    setx /M SONARQUBE_HOME C:\\sonarqube

RUN powershell -command \ 

    Invoke-WebRequest "https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$env:SONARQUBE_VERSION.zip" -OutFile "sonarqube.zip"; \

    Expand-Archive -Path c:\sonarqube.zip -DestinationPath C:\ ; \

    Remove-Item sonarqube.zip ; \

    Rename-Item sonarqube-$env:SONARQUBE_VERSION sonarqube ; \

    Rename-Item c:\sonarqube\extensions c:\sonarqube\original_extensions ;

VOLUME c:\\sonarqube

EXPOSE 9000

WORKDIR C:\\sonarqube

COPY sonarqube.cmd C:/sonarqube/bin/

CMD 
ENTRYPOINT ["C:\\sonarqube\\bin\\sonarqube.cmd"]