FROM openjdk:nanoserver

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN \
    setx /M SONARQUBE_VERSION '6.5'; \
    setx /M SONARQUBE_JDBC_URL 'jdbc:sqlserver://sonarserver3.database.windows.net:1433;database=sonar;user=sonar@sonarserver3;password=DevOps123#@!;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30'; \
    setx /M SONARQUBE_JDBC_USERNAME 'sonar@sonarserver3'; \
    setx /M SONARQUBE_JDBC_PASSWORD 'DevOps123#@!'; \
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
