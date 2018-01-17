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

    net use S: \\azurefiledriverac1.file.core.windows.net\cloudstor-metadata /u:AZURE\azurefiledriverac1 kZaxd8C98Bhjf3HO3YyDJpmBCrP/M5HbO4m/lg0oMqGnYXGBWqtKSNs7O7Rv8kztSgPT05hEbDoMxezFofyUXQ== ; \

    Expand-Archive -Path c:\sonarqube.zip -DestinationPath S:\ ; \

    Remove-Item sonarqube.zip ; \

    Rename-Item sonarqube-$env:SONARQUBE_VERSION sonarqube ; \

    Rename-Item S:\sonarqube\extensions S:\sonarqube\original_extensions ; 

VOLUME S:\\sonarqube\\extensions

EXPOSE 9000

WORKDIR S:\\sonarqube

COPY sonarqube.cmd S:/sonarqube/bin/

CMD 
ENTRYPOINT ["S:\\sonarqube\\bin\\sonarqube.cmd"]