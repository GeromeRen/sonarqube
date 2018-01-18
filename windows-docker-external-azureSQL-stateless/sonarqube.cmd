@Echo off
Setlocal
set _folder='S:\sonarqube\*.*'
set _TMP=
set sdrive=S:
set ssonarqubedrive=S:\sonarqube

echo "[Debug]SONARQUBE_JDBC_USERNAME is: %SONARQUBE_JDBC_USERNAME%"
echo "[Debug]SONARQUBE_JDBC_USERNAME is: %SONARQUBE_JDBC_USERNAME"


net use S: \\azurefiledriverac1.file.core.windows.net\sonarqube4windows1 /u:AZURE\azurefiledriverac1 kZaxd8C98Bhjf3HO3YyDJpmBCrP/M5HbO4m/lg0oMqGnYXGBWqtKSNs7O7Rv8kztSgPT05hEbDoMxezFofyUXQ==
for /f "delims=" %%a in ('dir /b "S:\sonarqube\*.*"') do set _TMP=%%a
echo "Checking Folder: %_folder%"
CD /D %sdrive%

if not exist "S:\sonarqube\" mkdir S:\sonarqube

IF {%_TMP%}=={} (
    echo 'First run'
	xcopy C:\sonarqube\* S:\sonarqube /e /i /h
) ELSE (
    echo 'Data exists, trying to start with your data'
)

CD /D %ssonarqubedrive%

java -jar lib/sonar-application-%SONARQUBE_VERSION%.jar -Dsonar.log.console=true -Dsonar.jdbc.username="chunyu.ren@sonarserver3" -Dsonar.jdbc.password="Aaaaaaa123!" -Dsonar.jdbc.url="jdbc:sqlserver://sonarserver3.database.windows.net:1433;database=sonar;user=chunyu.ren@sonarserver3;password=Aaaaaaa123!;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30" -Dsonar.web.javaAdditionalOpts="%SONARQUBE_WEB_JVM_OPTS% -Djava.security.egd=file:/dev/./urandom"