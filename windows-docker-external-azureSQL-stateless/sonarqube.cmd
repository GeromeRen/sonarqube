@Echo off
Setlocal
set _folder='S:\sonarqube\extensions\*.*'
set _TMP=
for /f "delims=" %%a in ('dir /b "S:\sonarqube\extensions\*.*"') do set _TMP=%%a
echo "Checking Folder: %_folder%"

IF {%_TMP%}=={} (
    echo 'First run'
	xcopy S:\sonarqube\original_extensions\* S:\sonarqube\extensions /e /i /h
) ELSE (
    echo 'Data exists, trying to start with your data'
)

java -jar lib/sonar-application-%SONARQUBE_VERSION%.jar -Dsonar.log.console=true -Dsonar.jdbc.username="%SONARQUBE_JDBC_USERNAME%" -Dsonar.jdbc.password="%SONARQUBE_JDBC_PASSWORD%" -Dsonar.jdbc.url="jdbc:sqlserver://%MS_AZURESQL_SERVER_NAME%:%MS_AZURESQL_SERVER_PORT%;database=sonar;user=%SONARQUBE_JDBC_USERNAME%;password=%SONARQUBE_JDBC_PASSWORD%;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30" -Dsonar.web.javaAdditionalOpts="%SONARQUBE_WEB_JVM_OPTS% -Djava.security.egd=file:/dev/./urandom"