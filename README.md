# Sonarqube
## SonarQube Windows Container with external Azure SQL Database
### To deploy a pre-built Docker container image in a Service Fabric application.

### Sample to run as Docker command
<pre>docker run --name sonar -it -p 9000:9000 \
                -v D:/sonarqube/extensions:C:/sonarqube/extensions \
                -e SONARQUBE_JDBC_USERNAME='****@****' \
                -e SONARQUBE_JDBC_PASSWORD='****' \
                -e MS_AZURESQL_SERVER_NAME='****' \
                -e MS_AZURESQL_SERVER_PORT='1433' \
                gerome/sonarqube-azuresql-windows-docker</pre>

## SonarQube Windows Container with internal MySQL Database (in the same container)
