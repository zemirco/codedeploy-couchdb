
# AWS CodeDeploy for CouchDB

A short tutorial for deploying CouchDB with AWS CodeDeploy.

Three steps are required:

1. [Setup IAM (Identity and Access Management)](#iam)
2. [Launch EC2 instance](#ec2)
3. [Use CodeDeploy to install CouchDB on EC2 instance](#codedeploy)

## IAM

You don't have to provision a user account if you're using AWS console
and not the aws-cli.

### Create an IAM Instance Profile and a Service Role

Create 2 specific IAM roles that are compatible with AWS CodeDeploy.

The first IAM role is called an IAM **instance profile**.
The second IAM role is called a **service role**.

#### Create an IAM Instance Profile

Your Amazon EC2 instances need permission to access the Amazon S3 buckets or GitHub repositories where you're storing your applications for AWS CodeDeploy to deploy.

**Important:** You must attach an IAM instance profile to an instance as you launch it. You cannot attach an IAM instance profile to an instance that has already been launched.

1. Sign in to the AWS Management Console and open the IAM console.

2. Click Roles, and then click Create New Role.

3. Give the IAM instance profile a name, e.g. ```"CodeDeployDemo-EC2"```

4. With AWS Service Roles already selected, click Select next to Amazon EC2.

5. On the Set Permissions page, click the Custom Policy option.

6. In the Policy Name box, type ```"CodeDeployDemo-EC2-Permissions"```.

  In the Policy Document box, paste the following:

  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": [
      "s3:Get*",
      "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
    ]
  }
  ```

7. On the Review page, click Create Role.

#### Create a Service Role for AWS CodeDeploy

AWS CodeDeploy relies on Amazon EC2 tags or Auto Scaling group names to identify Amazon EC2 instances that it can deploy applications to. To do this, AWS CodeDeploy needs access to your Amazon EC2 instances to expand (read) their tags or to identify your Amazon EC2 instances by the Auto Scaling group names that they're associated with.

1. Sign in to the AWS Management Console and open the IAM console.

2. Click Roles, and then click Create New Role.

3. In the Role Name box, give the service role a name, e.g. ```"CodeDeployDemo"```.

4. On the Select Role Type page, with AWS Service Roles already selected, next to Amazon EC2, click Select.

5. On the Set Permissions page, click Custom Policy.

6. In the Policy Name box, type ```"CodeDeployAccess"```.

7. In the Policy Document box, type the following policy.
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "autoscaling:PutLifecycleHook",
          "autoscaling:DeleteLifecycleHook",
          "autoscaling:RecordLifecycleActionHeartbeat",
          "autoscaling:CompleteLifecycleAction",
          "autoscaling:DescribeAutoscalingGroups",
          "autoscaling:PutInstanceInStandby",
          "autoscaling:PutInstanceInService",
          "ec2:Describe*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  ```

8. Click Create Role.

9. In the list of roles, browse to and click the role that you just created.

10. Under Trust Relationships, click Edit Trust Relationship.

11. Replace the entire contents of the Policy Document box with the following policy, and then click Update Trust Policy:
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "codedeploy.amazonaws.com"
          ]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  ```

12. Note the value of the Role ARN field, as you will need it to create deployment groups later.

## EC2

1. Choose AMI

  Ubuntu Server 14.04 LTS (HVM), SSD Volume Type

2. Choose Instance Type

  t2.micro

3. Configure Instance

  IAM role: couchdb-instance-profile

  Expand Advanced Details. Next to User data, with the As text option already selected.

  For the US East (N. Virginia) region:

  ```
  #!/bin/bash
  apt-get -y update
  apt-get -y install awscli
  apt-get -y install ruby2.0
  cd /home/ubuntu
  aws s3 cp s3://aws-codedeploy-us-east-1/latest/install . --region us-east-1
  chmod +x ./install
  ./install auto
  ```

4. Add Storage

5. Tag Instance

  Name: CouchDB

6. Configure Security Group

Create a new security group, e.g. "launch-wizard-2"

| type            | Protocol  | Port Range  | Source               |
|-----------------|-----------|-------------|----------------------|
| SSH             | TCP       | 22          | Anywhere 0.0.0.0/0   |
| Custom TCP Rule | TCP       | 5984        | Anywhere 0.0.0.0/0   |



## Codedeploy

1. Create New Application

  - Application Name: CouchDB
  - Deployment Group Name: CouchDB-Deployment-Group
  - Add Amazon EC2 Instances: Key: "Name", Value: "CouchDB"
  - Deployment Configuration: OneAtATime
  - Service Role: *:role/couchdb-role
