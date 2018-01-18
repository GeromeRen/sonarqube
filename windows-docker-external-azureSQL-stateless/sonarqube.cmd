@Echo off
Setlocal
set _TMP=
set _Azurefile_path=%AZUREFILE_DRIVE_LETTER%:%AZUREFILE_FOLDER%

net use %AZUREFILE_DRIVE_LETTER%: \\%AZUREFILE_URL% /u:AZURE\%AZUREFILE_ACC_NAME% %AZUREFILE_ACC_KEY%

for /f "delims=" %%a in ('dir /b "%_Azurefile_path%\*.*"') do set _TMP=%%a
echo "Checking Folder: %_Azurefile_path%\*.*"

CD /D %AZUREFILE_DRIVE_LETTER%

IF {%_TMP%}=={} (
    echo 'First run and create %_Azurefile_path%'
    mkdir %_Azurefile_path%
	xcopy C:\sonarqube\* %_Azurefile_path% /e /i /h
) ELSE (
	if exist "%_Azurefile_path%\temp" rmdir %_Azurefile_path%\temp /s /q
    echo 'Data exists, trying to start with your data'
)
CD /D %_Azurefile_path%

java -jar lib/sonar-application-%SONARQUBE_VERSION%.jar -Dsonar.log.console=true -Dsonar.jdbc.username="%SONARQUBE_JDBC_USERNAME%" -Dsonar.jdbc.password="%SONARQUBE_JDBC_PASSWORD%" -Dsonar.jdbc.url="jdbc:sqlserver://%MS_AZURESQL_SERVER_NAME%:%MS_AZURESQL_SERVER_PORT%;database=sonar;user=%SONARQUBE_JDBC_USERNAME%;password=%SONARQUBE_JDBC_PASSWORD%;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30" -Dsonar.web.javaAdditionalOpts="%SONARQUBE_WEB_JVM_OPTS% -Djava.security.egd=file:/dev/./urandom"