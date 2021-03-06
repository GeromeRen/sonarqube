# Overview
* Container is based on [Microsoft Nanoserver](https://hub.docker.com/r/microsoft/nanoserver/) and [OpenJDK](https://hub.docker.com/_/openjdk/) <br/>
* Follow instruction 1 in below to start SonarQube Windows Container using Azure SQL database as external database
* Follow instruction 2 in below to start stateless SonarQube Windows container using Azure SQL database as external database as well as mount the Azure File share directly within the container for SonarQube home directory using net use.
* Follow instruction 3 in below to start SonarQube Linux Unbuntu Container using Azure SQL database as external database and persist volume in docker host via Azure File SMB protocol.
* Follow instruction 4 in below to start stateless SonarQube Linux Ubuntu container using Azure SQL database as external database as well using a volume created with Cloudstor volume driver to mount entire SonarQube home directory as data volume.
* Follow links in instruction 5 in below to start SonarQube Linux Ubuntu container with inner MySQL database (database in same container in docker host).

# SonarQube Version
Version 6.5
# Getting Started Instructions
## 1. To deploy SonarQube using [this pre-built Windows Docker container image](https://hub.docker.com/r/gerome/sonarqube-azuresql-windows-docker/) in a Service Fabric application with Azure SQL Database. Check [this](https://github.com/GeromeRen/sonarqube/tree/master/windows-docker-external-azureSQL) out for Dockerfile build this image
### Prerequisite
* <strong>Create Azure Fabric Cluster in Azure</strong> - Select: Windows Data Center with Container <br>
* <strong>Create Azure SQL Database in Azure</strong> - Make sure to select collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube and 
* <strong>Expose port 9000 in your Azure Fabric Cluster Load Balancer for SonarQube to access</strong>
* <strong>Config firewall in sonarqube to allow service fabric cluster IP access</strong>
* Login the target host machine using RDP protocol to create persist volume d:\sonarqube\extensions in docker host
### Deploy SonarQube Windows Container Application
Follow https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers to create and deploy a SonarQube Windows Container Application

* in VSTS, New Project (ContainerizationSonarQubeWindowsAzureSQLProj) - Service Fabric Application - Container - Enter Image:  [gerome/sonarqube-azuresql-windows-docker](https://hub.docker.com/r/gerome/sonarqube-azuresql-windows-docker/) - Service Name (ContainerizationSonarQubeWindowsAzureSQLSrv)

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
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_NAME" Value="*****"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_PORT" Value="****"/>
  </EnvironmentVariables>
```
* Update SonarQube Service Endpoint:
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
Note: More volume to persist: https://github.com/SonarSource/docker-sonarqube/blob/master/recipes.md
```
### Verify SonarQube
SonarQube is running at Fabric endpoint: [http://{Your Fabric Cluster Endpoint}:9000]() and SonarQube Windows container persistence volume mount at d:\sonarqube on container host machine
                
## 2. To deploy SonarQube using [this pre-built Windows Stateless Docker container image](https://hub.docker.com/r/gerome/sonarqube-azuresql-windows-docker-stateless/) in a Service Fabric application with Azure SQL Database and Azure File to host SonarQube home directory for stateless. Check [this](https://github.com/GeromeRen/sonarqube/tree/master/windows-docker-external-azureSQL-stateless) out for Dockerfile build this image
### Prerequisite
* <strong>Create Azure Fabric Cluster in Azure</strong> - Select: Windows Data Center with Container <br>
* <strong>Create Azure SQL Database in Azure</strong> - Make sure to select collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube
* <strong>Create Azure File share in Azure</strong> - To host the entire SonarQube home directory
* <strong>Expose port 9000 in your Azure Fabric Cluster Load Balancer for SonarQube to access</strong>
* <strong>Config firewall in sonarqube to allow service fabric cluster IP access</strong>
### Deploy SonarQube Windows Container Application
Follow https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers to create and deploy a SonarQube Windows Container Application

* in VSTS, New Project (ContainerizationSonarQubeWindowsAzureSQLProj) - Service Fabric Application - Container - Enter Image:  [gerome/sonarqube-azuresql-windows-docker](https://hub.docker.com/r/gerome/sonarqube-azuresql-windows-docker/) - Service Name (ContainerizationSonarQubeWindowsAzureSQLSrv)

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
      <EnvironmentVariable Name="SONARQUBE_JDBC_USERNAME" Value="**@**"/>
      <EnvironmentVariable Name="SONARQUBE_JDBC_PASSWORD" Value="****"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_NAME" Value="****"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_PORT" Value="****"/>
      <EnvironmentVariable Name="AZUREFILE_DRIVE_LETTER" Value="****"/>
      <EnvironmentVariable Name="AZUREFILE_FOLDER" Value="****"/>
      <EnvironmentVariable Name="AZUREFILE_URL" Value="****"/>
      <EnvironmentVariable Name="AZUREFILE_ACC_NAME" Value="****"/>
      <EnvironmentVariable Name="AZUREFILE_ACC_KEY" Value="****"/>
  </EnvironmentVariables>
  
  e.g.
  <EnvironmentVariables>
      <EnvironmentVariable Name="SONARQUBE_JDBC_USERNAME" Value="chunyu.ren@sonarserver"/>
      <EnvironmentVariable Name="SONARQUBE_JDBC_PASSWORD" Value="mypassword"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_NAME" Value="sonarserver.database.windows.net"/>
      <EnvironmentVariable Name="MS_AZURESQL_SERVER_PORT" Value="1433"/>
      <EnvironmentVariable Name="AZUREFILE_DRIVE_LETTER" Value="Z"/>
      <EnvironmentVariable Name="AZUREFILE_FOLDER" Value="\sonarqube"/>
      <EnvironmentVariable Name="AZUREFILE_URL" Value="myaccount.file.core.windows.net\sonarqube4windows5"/>
      <EnvironmentVariable Name="AZUREFILE_ACC_NAME" Value="myaccount"/>
      <EnvironmentVariable Name="AZUREFILE_ACC_KEY" Value="kZaxd8C98Bhjf3HO......3YyDJpmBCrP/M5"/>
   </EnvironmentVariables>
```
* Update SonarQube Service Endpoint:
```bash
<Endpoint Name="FabricServiceSonarUbuntuTypeEndpoint" UriScheme="http" Port="9000" Protocol="http"/>
```
* In ApplicationManifest.xml, add below in ServiceManifestImport section to config container port-to-port binding:
```bash
<ConfigOverrides />
<Policies>
  <ContainerHostPolicies CodePackageRef="Code">
    <PortBinding ContainerPort="9000" EndpointRef="FabricServiceSonarUbuntuTypeEndpoint"/>
  </ContainerHostPolicies>
</Policies>
```
### Verify SonarQube
SonarQube is running at Fabric endpoint: [http://{Your Fabric Cluster Endpoint}:9000]() and SonarQube home directory will be entirely hosts in Azure file you created. This allows you to start/restart SonarQube as windows container in any desired node in Service Fabric cluster.
## 3. To deploy SonarQube as [a pre-built Linux docker container image](https://hub.docker.com/_/sonarqube/) in a Service Fabric application with Azure SQL Database and Azure File to persist volume in docker host
### Prerequisite
* <strong>Create Azure Fabric Cluster in Azure</strong> - Select: UbuntuServer 16.04-LTS
* <strong>Create Azure SQL Database in Azure</strong> - Make sure to select  collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube
* <strong>Expose port 9000 in your Azure Fabric Cluster Load Balancer for SonarQube to access</strong>
* <strong>Create Azure File in Azure</strong> - Mount as container host volume for SonarQube persistence using SMB protocol
Data Volumes with SMB Global mapping
Use RDP to access the Ubuntu machine: https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-nodetypes
* <strong>Expose port 9000 in your Azure Fabric Cluster Load Balancer for SonarQube to access</strong>
* <strong>Config firewall in sonarqube to allow service fabric cluster IP access</strong>
### Mount Azure file to Ubuntu machine to persist the volume
To connect to this file share from the Ubuntu machine (e.g. Mount point /data):
```bash
$sudo mount -t cifs //****.file.core.windows.net/azurefileshare1 /data -o vers=3.0,username={Your Store Account Name Here},password={Your Password Here},dir_mode=0777,file_mode=0777,sec=ntlmssp
```
### Deploy SonarQube Linux Container Application
Follow https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers to create and deploy a SonarQube Windows Container Application

* in VSTS, New Project (ContainerizationSonarQubeLinuxAzureSQLProj) - Service Fabric Application - Container - Enter Image:  [sonarqube:6.5](https://hub.docker.com/_/sonarqube/)- Service Name (ContainerizationSonarQubeWindowsAzureSQLSrv)

* In ServiceManifest.xml, add below in CodePackage section:
```bash
<EntryPoint>
  <ContainerHost>
    <ImageName>sonarqube:6.5</ImageName>
  </ContainerHost>
</EntryPoint>
<!-- Pass environment variables to your container: -->
<EnvironmentVariables>
  <EnvironmentVariable Name="SONARQUBE_JDBC_USERNAME" Value="****@****"/>
  <EnvironmentVariable Name="SONARQUBE_JDBC_PASSWORD" Value="****"/>
  <EnvironmentVariable Name="SONARQUBE_JDBC_URL" Value="jdbc:sqlserver://{Your Azure SQL DB Server Endpoint Here}:{{Your Azure SQL DB Server Port Here};database=sonar;user={SONARQUBE_JDBC_USERNAME Here};password={SONARQUBE_JDBC_PASSWORD Here};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30"/>
</EnvironmentVariables>
```

* Update SonarQube Service Endpoint:
```bash
<Endpoint Name="FabricServiceSonarUbuntuTypeEndpoint" UriScheme="http" Port="9000" Protocol="http"/>
```

* In ApplicationManifest.xml, add below in ServiceManifestImport section to config container port-to-port binding and volumes to mount
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

### Verify SonarQube
SonarQube is running at Fabric endpoint: [http://{Your Fabric Cluster Endpoint}:9000]() and SonarQube Linux container persistence volume mount at /data/sonarqube/*

## 4. To deploy SonarQube as [a pre-built Linux docker container image](https://hub.docker.com/_/sonarqube/) in a Service Fabric application with Azure SQL Database and docker Azure volume plugin to host SonarQube home directory for stateless
### Prerequisite
* <strong>Create Azure Fabric Cluster in Azure</strong> - Select: UbuntuServer 16.04-LTS
* <strong>Create Azure SQL Database in Azure</strong> - Make sure to select  collation as SQL_Latin1_General_CP1_CS_AS as required by SonarQube
* <strong>Expose port 9000 in your Azure Fabric Cluster Load Balancer for SonarQube to access</strong>
* <strong>Create Azure File share in Azure</strong> - To host the entire SonarQube home directory
Use RDP to access the Ubuntu machine: https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-nodetypes
* <strong>Expose port 9000 in your Azure Fabric Cluster Load Balancer for SonarQube to access</strong>
* <strong>Config firewall in sonarqube to allow service fabric cluster IP access</strong>
### Install the Docker volume driver for Azure
Host Sonarqube home directory in Azure Files, this allow your Sonarqube container is moved or restarted on a different host. 
<strong>Install it manually in desired Service Fabric cluster nodes by using the RDP/SSH protocols:</strong>
```
docker plugin install --alias cloudstor:azure \
  --grant-all-permissions docker4x/cloudstor:17.06.1-ce-azure1  \
  CLOUD_PLATFORM=AZURE \
  AZURE_STORAGE_ACCOUNT_KEY="kZaxd8C98Bhjf3HO3YyDJpmBCrP/M5HbO4m....kztSgPT05hEbDoMxezFofyUXQ==" \
  AZURE_STORAGE_ACCOUNT="yourazurestorageacct" \
  DEBUG=1
```
More about volume driver detail refer to https://docs.docker.com/docker-for-azure/persistent-data-volumes/ and https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-containers-volume-logging-drivers
### Deploy SonarQube Linux Container Application
Follow https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers to create and deploy a SonarQube Windows Container Application

* in VSTS, New Project (ContainerizationSonarQubeLinuxAzureSQLProj) - Service Fabric Application - Container - Enter Image:  [sonarqube:6.5](https://hub.docker.com/_/sonarqube/)- Service Name (ContainerizationSonarQubeWindowsAzureSQLSrv)

* In ServiceManifest.xml, add below in CodePackage section:
```bash
<EntryPoint>
  <ContainerHost>
    <ImageName>sonarqube:6.5</ImageName>
  </ContainerHost>
</EntryPoint>
<!-- Pass environment variables to your container: -->
<EnvironmentVariables>
  <EnvironmentVariable Name="SONARQUBE_JDBC_USERNAME" Value="****@****"/>
  <EnvironmentVariable Name="SONARQUBE_JDBC_PASSWORD" Value="****"/>
  <EnvironmentVariable Name="SONARQUBE_JDBC_URL" Value="jdbc:sqlserver://{Your Azure SQL DB Server Endpoint Here}:{{Your Azure SQL DB Server Port Here};database=sonar;user={SONARQUBE_JDBC_USERNAME Here};password={SONARQUBE_JDBC_PASSWORD Here};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30"/>
</EnvironmentVariables>
```

* Update SonarQube Service Endpoint:
```bash
<Endpoint Name="FabricServiceSonarUbuntuTypeEndpoint" UriScheme="http" Port="9000" Protocol="http"/>
```

* In ApplicationManifest.xml, add below in ServiceManifestImport section to config container port-to-port binding and volumes to mount using created cloudstor Azure volume driver
```bash
<ConfigOverrides />
<Policies>
  <ContainerHostPolicies CodePackageRef="Code">
    <PortBinding ContainerPort="9000" EndpointRef="FabricServiceSonarUbuntuTypeEndpoint"/>
    <Volume Source="sonarhomevolume" Destination="/opt/sonarqube" Driver="cloudstor:azure" IsReadOnly="false">
      <DriverOption Name="share" Value="sonarhomevolume"/>
    </Volume>
  </ContainerHostPolicies>
</Policies>
```

### Verify SonarQube
SonarQube is running at Fabric endpoint: [http://{Your Fabric Cluster Endpoint}:9000]() and SonarQube home directory /opt/sonarqube will be entirely hosts in Azure file via volume plugin for stateless

## 5. To deploy SonarQube as Windows docker container image with internal MySQL Database (database in same container in docker host)
Please reference to: https://github.com/dnikolayev/sonarqube-mysql-windows-docker
