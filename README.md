# Sonarqube
## SonarQube Windows Container with external Azure SQL Database
### To deploy a pre-built Docker container image in a Service Fabric application.
#### Prerequisite
Create Azure Fabric Cluster in Azure - Select: Windows Data Center with Container
Create Azure SQL Database in Azure - Make sure to select  collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube
####Deploy SonarQube Windows Container Application
Follow https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers to create and deploy a SonarQube Windows Container Application

1. in VSTS, New Project (ContainerizationSonarQubeWindowsAzureSQLProj) - Service Fabric Application - Container - Enter Image:  gerome/sonarqube-azuresql-windows-docker - Service Name (ContainerizationSonarQubeWindowsAzureSQLSrv)

2. In ServiceManifest.xml, add below in CodePackage section:
```bash
<EntryPoint>
  <!-- Follow this link for more information about deploying Windows containers to Service Fabric: https://aka.ms/sfguestcontainers -->
  <ContainerHost>
    <ImageName>gerome/sonarqube-azuresql-windows-docker</ImageName>
  </ContainerHost>
  </EntryPoint>
  <!-- Pass environment variables to your container: -->
  <EnvironmentVariables>
      <EnvironmentVariable Name="SONARQUBE_JDBC_USERNAME" Value="sonar@sonarserver3"/>
      <EnvironmentVariable Name="SONARQUBE_JDBC_PASSWORD" Value="Dev***123***"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_NAME" Value="sonarserver3.database.windows.net"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_PORT" Value="1433"/>
  </EnvironmentVariables>
```
Update SonarQube Service Endpoint:
<pre>
<Endpoint Name="FabricServiceSonarUbuntuTypeEndpoint" UriScheme="http" Port="9000" Protocol="http"/>
</pre>
3. In ApplicationManifest.xml, add below in ServiceManifestImport section to config container port-to-port binding:
<pre>
<ConfigOverrides />
<Policies>
  <ContainerHostPolicies CodePackageRef="Code">
    <PortBinding ContainerPort="9000" EndpointRef="FabricServiceSonarUbuntuTypeEndpoint"/>
    <Volume Source="d:\sonarqube\extensions" Destination="c:\sonarqube\extensions" IsReadOnly="false"> </Volume>
  </ContainerHostPolicies>
</Policies>
</pre>
### To run as Docker command
<pre>docker run --name sonar -it -p 9000:9000 \
                -v D:/sonarqube/extensions:C:/sonarqube/extensions \
                -e SONARQUBE_JDBC_USERNAME='****@****' \
                -e SONARQUBE_JDBC_PASSWORD='****' \
                -e MS_AZURESQL_SERVER_NAME='****' \
                -e MS_AZURESQL_SERVER_PORT='1433' \
                gerome/sonarqube-azuresql-windows-docker</pre>

## SonarQube Windows Container with internal MySQL Database (in the same container)
