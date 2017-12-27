# Overview
* Container is based on [Microsoft Nanoserver](https://hub.docker.com/r/microsoft/nanoserver/) and [OpenJDK](https://hub.docker.com/_/openjdk/) <br/>
* Container use Azure SQL Database as external database
# SonarQube Version
Version 6.5
# Getting Started Instructions
## 1. To deploy a pre-built Docker container image in a Service Fabric application.
#### Prerequisite
<strong>Create Azure Fabric Cluster in Azure</strong> - Select: Windows Data Center with Container <br>
<strong>Create Azure SQL Database in Azure</strong> - Make sure to select  collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube
#### Deploy SonarQube Windows Container Application
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
#### Verify SonarQube
SonarQube is running at Fabric endpoint: http://fabric21.eastus2.cloudapp.azure.com:9000 <br>
SonarQube Windows container persistence volume mount at d:\sonarqube on container host machine <br>
Note: Remember to expose port 9000 in your Azure Load Balancer 

## 2. To Run as Docker Command Line
<pre>docker run --name sonar -it -p 9000:9000 \
                -v D:/sonarqube/extensions:C:/sonarqube/extensions \
                -e SONARQUBE_JDBC_USERNAME='****@****' \
                -e SONARQUBE_JDBC_PASSWORD='****' \
                -e MS_AZURESQL_SERVER_NAME='****' \
                -e MS_AZURESQL_SERVER_PORT='****' \
                gerome/sonarqube-azuresql-windows-docker</pre>

#  More to Read
## SonarQube Windows Container with internal MySQL Database (in the same container)
Please reference to: https://github.com/dnikolayev/sonarqube-mysql-windows-docker

## SonarQube as Linux Utuntu Container with Azure SQL DB in Azure Fabric Cluster
Prerequisite
Create Azure Fabric Cluster in Azure - Select: UbuntuServer 16.04-LTS
Create Azure SQL Database in Azure - Make sure to select  collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube
Create Azure File in Azure - Mount as container host volume for SonarQube persistence using SMB protocol
Data Volumes with SMB Global mapping
Use RDP to access the Ubuntu machine: https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-nodetypes

To connect to this file share from the Ubuntu machine:
```bash
$sudo mount -t cifs //geromestorageacct1.file.core.windows.net/azurefileshare1 /data -o vers=3.0,username=geromestorageacct1,password=cfekb0EQtSaaCKkSvQXGIr8iJMZLxWB5e2d+uu0WkuOo8OQmLtrtQFqFeh5MqGZCRJUONr7tn1eB2T9yCeIkHg==,dir_mode=0777,file_mode=0777,sec=ntlmssp
```

Deploy SonarQube Linux Container Application
Follow https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers to create and deploy a SonarQube Windows Container Application

1. in VSTS, New Project (ContainerizationSonarQubeLinuxAzureSQLProj) - Service Fabric Application - Container - Enter Image:  sonarqube:6.5- Service Name (ContainerizationSonarQubeWindowsAzureSQLSrv)

2. In ServiceManifest.xml, add below in CodePackage section:
```bash
<EntryPoint>
  <!-- Follow this link for more information about deploying Windows containers to Service Fabric: https://aka.ms/sfguestcontainers -->
  <ContainerHost>
    <ImageName>sonarqube:6.5</ImageName>
  </ContainerHost>
</EntryPoint>
<!-- Pass environment variables to your container: -->
<EnvironmentVariables>
  <EnvironmentVariable Name="SONARQUBE_JDBC_USERNAME" Value="sonar@sonarserver3"/>
  <EnvironmentVariable Name="SONARQUBE_JDBC_PASSWORD" Value="DevOps123#@!"/>
  <EnvironmentVariable Name="SONARQUBE_JDBC_URL" Value="jdbc:sqlserver://sonarserver3.database.windows.net:1433;database=sonar;user=sonar@sonarserver3;password=DevOps123#@!;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30"/>
</EnvironmentVariables>
```

Update SonarQube Service Endpoint:

<Endpoint Name="FabricServiceSonarUbuntuTypeEndpoint" UriScheme="http" Port="9000" Protocol="http"/>
 

3. In ApplicationManifest.xml, add below in ServiceManifestImport section to config container port-to-port binding:
```bash
<ConfigOverrides />
<Policies>
  <ContainerHostPolicies CodePackageRef="Code">
    <PortBinding ContainerPort="9000" EndpointRef="FabricServiceSonarUbuntuTypeEndpoint"/>
    <Volume Source="/data/sonarqube/conf" Destination="/opt/sonarqube/conf" IsReadOnly="false"></Volume>
    <Volume Source="/data/sonarqube/data" Destination="/opt/sonarqube/data" IsReadOnly="false"></Volume>
    <Volume Source="/data/sonarqube/extensions" Destination="/opt/sonarqube/extensions" IsReadOnly="false"></Volume>
    <Volume Source="/data/sonarqube/lib/bundled-plugins" Destination="/opt/sonarqube/lib/bundled-plugins" IsReadOnly="false"></Volume>
  </ContainerHostPolicies>
</Policies>
```

Verify SonarQube
SonarQube is running at Fabric endpoint: http://fabric21.eastus2.cloudapp.azure.com:9000 

SonarQube Linux container persistence volume mount at /data/sonarqube/*

