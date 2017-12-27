# Overview
Containers are based on [Microsoft Nanoserver](https://hub.docker.com/r/microsoft/nanoserver/) and [OpenJDK](https://hub.docker.com/_/openjdk/)
## SonarQube Windows Container with external Azure SQL Database

### To deploy a pre-built Docker container image in a Service Fabric application.
#### 1. Prerequisite
<strong>Create Azure Fabric Cluster in Azure</strong> - Select: Windows Data Center with Container <br>
<strong>Create Azure SQL Database in Azure</strong> - Make sure to select  collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube
#### 2. Deploy SonarQube Windows Container Application
Follow https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers to create and deploy a SonarQube Windows Container Application

* in VSTS, New Project (ContainerizationSonarQubeWindowsAzureSQLProj) - Service Fabric Application - Container - Enter Image:  gerome/sonarqube-azuresql-windows-docker - Service Name (ContainerizationSonarQubeWindowsAzureSQLSrv)

* In ServiceManifest.xml, add below in CodePackage section:
```bash
<EntryPoint>
  <!-- Follow this link for more information about deploying Windows containers to Service Fabric: https://aka.ms/sfguestcontainers -->
  <ContainerHost>
    <ImageName>gerome/sonarqube-azuresql-windows-docker</ImageName>
  </ContainerHost>
  </EntryPoint>
  <!-- Pass environment variables to your container: -->
  <EnvironmentVariables>
      <EnvironmentVariable Name="SONARQUBE_JDBC_USERNAME" Value="****@****"/>
      <EnvironmentVariable Name="SONARQUBE_JDBC_PASSWORD" Value="****"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_NAME" Value="****.database.windows.net"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_PORT" Value="1433"/>
  </EnvironmentVariables>
```
Update SonarQube Service Endpoint:
```bash
<Endpoint Name="FabricServiceSonarUbuntuTypeEndpoint" UriScheme="http" Port="9000" Protocol="http"/>
```
* In ApplicationManifest.xml, add below in ServiceManifestImport section to config container port-to-port binding:
```bash
<ConfigOverrides />
<Policies>
  <ContainerHostPolicies CodePackageRef="Code">
    <PortBinding ContainerPort="9000" EndpointRef="FabricServiceSonarUbuntuTypeEndpoint"/>
    <Volume Source="d:\sonarqube\extensions" Destination="c:\sonarqube\extensions" IsReadOnly="false"> </Volume>
  </ContainerHostPolicies>
</Policies>
```
#### 3. Verify SonarQube
SonarQube is running at Fabric endpoint: http://fabric21.eastus2.cloudapp.azure.com:9000 <br>
SonarQube Windows container persistence volume mount at d:\sonarqube on container host machine <br>
Note: Remember to expose port 9000 in your Azure Load Balancer 

### To run as Docker command
<pre>docker run --name sonar -it -p 9000:9000 \
                -v D:/sonarqube/extensions:C:/sonarqube/extensions \
                -e SONARQUBE_JDBC_USERNAME='****@****' \
                -e SONARQUBE_JDBC_PASSWORD='****' \
                -e MS_AZURESQL_SERVER_NAME='****.database.windows.net' \
                -e MS_AZURESQL_SERVER_PORT='1433' \
                gerome/sonarqube-azuresql-windows-docker</pre>

## SonarQube Windows Container with internal MySQL Database (in the same container)
Please reference to: https://github.com/dnikolayev/sonarqube-mysql-windows-docker
