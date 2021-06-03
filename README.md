# aws-fargate-example

The code in this github repository gives a step-by-step instruction on how to integrate a Contrast Security agent with an application being deployed to an Amazon EKS cluster via AWS Fargate.

![Contrast Fargate-EKS Integration Example](/diagrams/aws-fargate-contrast-security-integration-1a.png)

This github repository contains the following sections:
* Sample Application with Vulnerabilities - Webgoat
* Docker Build/Docker-Compose Deployment
* Pushing the Container Image to Amazon ECR
* Amazon EKS Deployment via AWS Fargate
* Simple Exploit (SQL Injection)
* Contrast Security Vulnerability Results

## Sample Application with Vulnerabilities - Webgoat

The sample application is based on [OWASP WebGoat - version 7](https://github.com/WebGoat) - vulnerabilities have been added for demonstration purposes.

The Webgoat application was developed on the java framework.  This guide assumes that the user has knowledge on how to instrument a java application with a Contrast Security Agent.  

For more information on how to instrument a java application with a Contrast Security Agent, please visit the link [here](https://docs.contrastsecurity.com/en/install-the-java-agent.html).

## Docker Build/Docker-Compose Deployment

You can run Webgoat within a Docker container locally via docker-compose as tested on OSX. The agent is added automatically during the Docker build process.

1.) Build the container using:

`docker build -f Dockerfile . -t <ADD>`

2.) Run the containers locally via Docker-Compose using: 

`docker-compose up`

*Note - For vanilla Docker implementations including docker-compose, the agent configurations are passed via environment variables within the Dockerfile.  Make sure to use 'Dockerfile' for vanilla Docker implementations for the docker build.  If you are deploying to Amazon EKS, please use 'Dockerfile' for the docker build as the Contrast Agent configurations are removed from the Dockerfile.  For Amazon EKS implementations, Contrast Agent configurations are passed using kubernetes secrets/configMaps.* 

## Pushing the Container Image to Amazon ECR

Following your build, in order to run the application via Amazon EKS, you first need to have an image avialable inside a Container Registry.  This demo uses Amazon's ECR to store the built container images. 

1.) Make sure to tag the image prior to pushing to the registry using this command:

`docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]`

2.) Log into Amazon's ECR using the following command - more information found <ADD>:

`docker login <ADD>`

3.) Push a local container image to Amazon's ECR using the 'docker' command:

`docker push NAME[:TAG]`

## Amazon EKS Deployment via AWS Fargate

The Webgoat application can also be deployed to a Kubernetes cluster as tested on local OSX via Kubernetes running locally on Docker Desktop and the Amazon EKS PaaS environment. 

### Create a kubernetes secret to store Contrast Agent configurations

1.) Update the 'contrast_security.yaml' with your configuration details.

2.) Create a kubernetes secret that houses the Contrast Security agent configuration from the 'contrast_security' file:

`kubectl create secret generic contrast-security --from-file=./contrast_security.yaml`

*Note - You need to be in the same directory that contains the 'contrast_security.yaml' file, unless you explicitly pass the file location to kubectl as above.*

### Deploy Webgoat to an EKS cluster via AWS Fargate

1.) Make sure your EKS cluster can pull images from your ECR - more information found <ADD>

2.) Find the manifests in 'kubernetes/manifests'

3.) Run the following code to deploy using kubectl:

`kubectl apply -f webgoat-deployment.yaml,webgoat-service.yaml`

*Note - You need to be in the same directory that contains the manifests, unless you explicitly pass the file location to kubectl.*

## Simple exploit (SQL Injection)

To expose a sample SQL Injection vulnerability:
* login 
  *  inspect the loadbalancer service you have deployed to get the IP - add '/WebGoat' to the URL 
  `<IP ADDRESS>/WebGoat`
  *  credentials - email: webgoat, password: webgoat
*  <ADD>

`<ADD>`

Once the search functionality is exploited, the following results should come back from the database.

## Contrast Security Vulnerability Results

Results from the Contrast Agent should resemble the following: 

*Note - More information on Contrast Security can be found [here](www.contrastsecurity.com)*
