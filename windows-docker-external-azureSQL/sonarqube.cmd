@Echo off
Setlocal
set _folder='C:\sonarqube\extensions\*.*'


:: Is folder empty
set _TMP=
for /f "delims=" %%a in ('dir /b "C:\sonarqube\extensions\*.*"') do set _TMP=%%a
echo "Checking Folder: %_folder%"

IF {%_TMP%}=={} (
    echo 'First run'
	xcopy C:\sonarqube\original_extensions\* C:\sonarqube\extensions /e /i /h
) ELSE (
    echo 'Data exists, trying to start with your data'
)

java -jar lib/sonar-application-%SONARQUBE_VERSION%.jar -Dsonar.log.console=true -Dsonar.jdbc.username="%SONARQUBE_JDBC_USERNAME%" -Dsonar.jdbc.password="%SONARQUBE_JDBC_PASSWORD%" -Dsonar.jdbc.url="%SONARQUBE_JDBC_URL%" -Dsonar.web.javaAdditionalOpts="%SONARQUBE_WEB_JVM_OPTS% -Djava.security.egd=file:/dev/./urandom"