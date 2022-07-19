# helloworld serverless API
The helloworld project, created with [`aws-serverless-java-container`](https://github.com/awslabs/aws-serverless-java-container).

The starter project defines a simple `/ping` resource that can accept `GET` requests with its tests.

The project folder also includes a `template.yml` file. You can use this [SAM](https://github.com/awslabs/serverless-application-model) file to deploy the project to AWS Lambda and Amazon API Gateway or test in local with the [SAM CLI](https://github.com/awslabs/aws-sam-cli). 

#[[* [AWS CLI](https://aws.amazon.com/cli/)
* [SAM CLI](https://github.com/awslabs/aws-sam-cli)
* [Gradle](https://gradle.org/) or [Maven](https://maven.apache.org/)

#[[You can use the SAM CLI to quickly build the project
```bash
$ mvn archetype:generate -DartifactId=helloworld -DarchetypeGroupId=com.amazonaws.serverless.archetypes -DarchetypeArtifactId=aws-serverless-jersey-archetype -DarchetypeVersion=1.8.2 -DgroupId=com.example -Dversion=0.0.1-SNAPSHOT -Dinteractive=false
$ cd helloworld
$ sam build
Building resource 'HelloworldFunction'
Running JavaGradleWorkflow:GradleBuild
Running JavaGradleWorkflow:CopyArtifacts

Build Succeeded

Built Artifacts  : .aws-sam/build
Built Template   : .aws-sam/build/template.yaml

Commands you can use next
=========================
[*] Invoke Function: sam local invoke
[*] Deploy: sam deploy --guided
```

#[[
From the project root folder - where the `template.yml` file is located - start the API with the SAM CLI.

```bash
$ sam local start-api

...
Mounting com.amazonaws.serverless.archetypes.StreamLambdaHandler::handleRequest (java8) at http://127.0.0.1:3000/{proxy+} [OPTIONS GET HEAD POST PUT DELETE PATCH]
...
```

Using a new shell, you can send a test ping request to your API:

```bash
$ curl -s http://127.0.0.1:3000/ping | python -m json.tool

{
    "pong": "Hello, World!"
}
``` 

#[[To deploy the application in your AWS account, you can use the SAM CLI's guided deployment process and follow the instructions on the screen

```
$ sam deploy --guided
```

Once the deployment is completed, the SAM CLI will print out the stack's outputs, including the new application URL. You can use `curl` or a web browser to make a call to the URL

```
...
-------------------------------------------------------------------------------------------------------------
OutputKey-Description                        OutputValue
-------------------------------------------------------------------------------------------------------------
HelloworldApi - URL for application            https://xxxxxxxxxx.execute-api.us-west-2.amazonaws.com/Prod/pets
-------------------------------------------------------------------------------------------------------------
```

Copy the `OutputValue` into a browser or use curl to test your first request:

```bash
$ curl -s https://xxxxxxx.execute-api.us-west-2.amazonaws.com/Prod/ping | python -m json.tool

{
    "pong": "Hello, World!"
}
```

# Steps to deploy helloworld serverless API in Lambda from Container Image & Access it through Application Load Balancer

Following are the steps required to build Docker images & push the image to AWS ECR 

Pre-requisites

* [AWS CLI](https://aws.amazon.com/cli/)
* Maven](https://maven.apache.org/)
* Docker Desktop

Steps:

- Create docker image by running `docker build . -t <image name>:<version>`
- Once the image is created, use following steps to publish the image to AWS ECR

```
-- Login
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account id>.dkr.ecr.<region>.amazonaws.com

-- Create Repo in ECR
aws ecr create-repository --repository-name <repo name> --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE

-- Tag the image
docker tag <image name>:<version> <account id>.dkr.ecr.<region>.amazonaws.com/<image name>:<version>

-- Push image to ECR
docker push <account id>.dkr.ecr.<region>.amazonaws.com/<image name>:<version>
```

After image is pushed to AWS ECR, find below the steps to setup Lambda 

- Login to AWS Console
- Select appropriate region where you push docker images
- Open Lambda
- Launch `Create Function`
- Select `Container Image` option
- Select your docker image from dropdown
- Let AWS create new IAM role

Once the Lambda is created, open IAM and go to the role created by AWS. In that click `Add Permissions` and add following IAM policy

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:AttachNetworkInterface"
            ],
            "Resource": "arn:aws:ec2:<region>:<account id>:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeNetworkInterfaces"
            ],
            "Resource": "*"
        }
    ]
}
```

Once Application Load Balancer & Target Group for Lambda is created, you can access REST API using Application Load Balancer endpoint
