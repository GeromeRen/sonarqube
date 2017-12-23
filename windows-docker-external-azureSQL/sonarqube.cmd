@Echo off
Setlocal
set _folder='C:\sonarqube\extensions\*.*'
set _sonarqube_jdbc_username=%1		
set _sonarqube_jdbc_password=%2		
set _ms_azuresql_server_name=%3		
set _ms_azuresql_server_port=%4
set _sonarqube_jdbc_url='jdbc:sqlserver://%_ms_azuresql_server_name%:%_ms_azuresql_server_port%;database=sonar;user=%_sonarqube_jdbc_username%;password=%_sonarqube_jdbc_password%;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30'; \

set _TMP=
for /f "delims=" %%a in ('dir /b "C:\sonarqube\extensions\*.*"') do set _TMP=%%a
echo "Checking Folder: %_folder%"

IF {%_TMP%}=={} (
    echo 'First run'
	xcopy C:\sonarqube\original_extensions\* C:\sonarqube\extensions /e /i /h
) ELSE (
    echo 'Data exists, trying to start with your data'
)
echo "***********[DEBUG]SONARQUBE_JDBC_URL*****************"
echo "%_sonarqube_jdbc_url%"

java -jar lib/sonar-application-%SONARQUBE_VERSION%.jar -Dsonar.log.console=true -Dsonar.jdbc.username="%_sonarqube_jdbc_username%" -Dsonar.jdbc.password="%_sonarqube_jdbc_password%" -Dsonar.jdbc.url="%_sonarqube_jdbc_url%" -Dsonar.web.javaAdditionalOpts="%SONARQUBE_WEB_JVM_OPTS% -Djava.security.egd=file:/dev/./urandom"