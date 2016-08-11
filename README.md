# Jenkins Docker

This is an example of having a custom Jenkins docker container that manages basic job configuration with pre-installed plugins.

## Docker Information

You can build a new container and run it.

### Configuration

If you are forking any of the repositories into your own (due to read-only access rights) you will need to update job-configurations files to use your mirrored/forked repository locations.

### Build

docker build --rm=true -t myjenkins .

### Run

docker run --name myjenkins -p 8081:8080 -p 50001:50000 myjenkins

## Jenkins Initial Configuration

You need to do some Jenkins configuration before you have a running demo.

### Credentials

You will need to set these credentials for this demo

- GitHubTokenCredentialsId
    - Username/Password credentials needed for GitHub Scanning (credentials need read access to GitHub).
- GitHubSSHCredentialsId
    - SSH username with private key credentials needed for code checkout (RW access) from GitHub.
- GitHubToken
    - Secret Text credentials that contains the GitHub API Token (Read access) for Global Jenkins GitHub access.
- DockerHostSSHCredentialsId
    - Username/Password SSH login credentials for Jenkins Slave Node that has Docker pre-installed.
    
### Global Configuration

You will need to configure the system for a GitHub api access and add the slave node. You may optionally want to disable authentication.

#### GitHub Server

Under global configuration (Manage Jenkins -> Configure System) you will see a 'GitHub' section. In there you will need to add a new GitHub Server.
Once added select the 'GitHubToken' credentials and save the configuration.

#### Jenkins Slave Node

Under Jenkins Node management (Manage Jenkins -> Manage Nodes) you can add a new slave node.

Add a new permanent agent named accordingly.
Fill in the appropriate information and specify 'dockerhost loadtest' under the labels section.
For the launch method select launch slave on Unix machine via SSH and select the appropriate SSH Slave credentials.

#### Jenkins Authentication

You may want to disable Jenkins UI authentication for ease of use with the demo environment.

To do this go to Global security (Manage Jenkins -> Configure Global Security) and under the authorization select 'Anyone can do anything'

### Seed-JobDSL

Once everything is setup you can run the Seed-JobDSL job which will create the basic job configuration using JobDSL plugin.