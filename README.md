
# AWS CodeDeploy for CouchDB

A short tutorial for deploying CouchDB with AWS CodeDeploy.

Three steps are required:
1. Setup IAM (Identity and Access Management)
2. Launch EC2 instance
3. Use CodeDeploy to install CouchDB on EC2 instance

## IAM

### Provision an IAM User Account

1. Create an IAM user account

  couchdb-user

2. Grant the IAM user account access to AWS CodeDeploy

  Attach User Policy -> Custom Policy

  - Policy Name: couchdb-codedeployment-policy
  - Policy Document:
    ```json
    {
      "Version": "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:*",
            "codedeploy:*",
            "ec2:*",
            "elasticloadbalancing:*",
            "iam:AddRoleToInstanceProfile",
            "iam:CreateInstanceProfile",
            "iam:CreateRole",
            "iam:DeleteInstanceProfile",
            "iam:DeleteRole",
            "iam:DeleteRolePolicy",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListInstanceProfilesForRole",
            "iam:ListRolePolicies",
            "iam:ListRoles",
            "iam:PassRole",
            "iam:PutRolePolicy",
            "iam:RemoveRoleFromInstanceProfile",
            "s3:*"
          ],
          "Resource" : "*"
        }
      ]
    }
    ```

### Create an IAM Instance Profile and a Service Role

Create 2 specific IAM roles that are compatible with AWS CodeDeploy.

The first IAM role is called an IAM **instance profile**.
The second IAM role is called a **service role**.

#### Create an IAM Instance Profile for Your Amazon EC2 Instances

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

###### rest

Create IAM (Identity and Access Management) via AWS console.

[Create an IAM Instance Profile for Your Amazon EC2 Instances](http://docs.aws.amazon.com/codedeploy/latest/userguide/how-to-create-iam-instance-profile.html)

Role ARN
arn:aws:iam::824763766161:role/couchdb-role



## EC2

1. Choose AMI

  Ubuntu Server 14.04 LTS (HVM), SSD Volume Type

2. Choose Instance Type

  t2.micro

3. Configure Instance

  IAM role: couchdb-instance-profile

4. Add Storage

5. Tag Instance

  Name: CouchDB

6. Configure Security Group

Create a new security group, e.g. "launch-wizard-2"

|type  | Protocol  | Port Range  | Source               |
|------|-----------|-------------|----------------------|
|SSH   | TCP       | 22          | Anywhere 0.0.0.0/0   |



## Codedeploy

1. Create an application

2. Create New Application

  - Application Name: CouchDB
  - Deployment Group Name: CouchDB-Deployment-Group
  - Add Amazon EC2 Instances: Key: "Name", Value: "CouchDB"
  - Deployment Configuration: OneAtATime
  - Service Role: *:role/couchdb-role

## Rest

Create revision by zipping all files.
A revision includes `appspec.yml`, `scripts/` and all app files.

```

```
