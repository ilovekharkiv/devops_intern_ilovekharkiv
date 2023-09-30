# Task 1 DevOps 1.0

## Table of Contents
#### [1. Instructions for task DO_1](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/tree/DO_2#instructions-for-task-do_1)
#### [2. Instructions for task DO_2](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/tree/DO_2#instructions-for-task-do_2)
#### [3. Instructions for task DO_3]()
#### [3. Instructions for task DO_4](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/tree/DO_4#instructions-for-task-do_4)


## Instructions for task DO_1 
<details>
<summary>Click to expand</summary>

### Step 1. Download the repository with Dockerfile 

Click this [Link](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/archive/refs/heads/DO_1.zip). Once it is downloaded, locate it on your computer and open the terminal form repo's root folder. You will find the files that you need for launching the script.

### Step 2. Rename .env.sample => .env

You will find .env.sample inside the repo and you need ti rename it to `.env`. The content of the file is the following:

```bash
REPO_SSH_URL="git@github.com:ilovekharkiv/devops_intern_ilovekharkiv.git"
BACKUP_DIR=backup
REPO_NAME="git@github.com:ilovekharkiv"
MAX_BACKUPS=$MAX_BACKUPS # Default value = 3. You need to choose the amount of backups you would like to generate. Please keep in mind that MAX_BACKUPS has to be >0, otherwise backup won't be created
RUN_AMOUNT=$RUN_AMOUNT  # Default value = 3. This is the amount of runs, which script will do before it stops.
DB_USER=
DB_PASSWORD=
DB_ENDPOINT=
DB_NAME=
```

### Step 3. Build an image

```bash
docker build -t my_backup .
```

### Step 4. Run the container

This is an example of the script with custom values for `MAX_BACKUPS` and `RUN_AMOUNT`

```
docker run -it \
-v $(pwd)/backup:/backup \
-v $SSH_AUTH_SOCK:/ssh-agent \
-v /home/$USER/.ssh:/root/.ssh/known_hosts \
-e SSH_AUTH_SOCK=/ssh-agent \
my_backup
``` 
</details>

## Instructions for task DO_2
<details>
<summary>Click to expand</summary>

### Step 1. Download the repository 

Click this [Link](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/archive/refs/heads/DO_2.zip). Once it is downloaded, locate it on your computer and open the terminal form repo's root folder. You will find the files that you need for launching docker-compose.

### Step 2. Rename .env.sample => .env

You will find .env.sample inside the repo and you need ti rename it to `.env` and update the values where needed (`db_user,db_password,db_endpoint,db_name`). The content of the file is the following:

```bash
DB_USER=dbuser
DB_PASSWORD=dbpassword
DB_ENDPOINT=dbpostgres
DB_NAME=postgres
POSTGRES_HOST_AUTH_METHOD=trust 
PORT_BACKEND=8000
PORT_FRONTEND=4200
PORT_NGINX=80
PORT_DATABASE=5432
```

### Step 3. Run docker-compose.yml from project root directory with the following command:

```
docker-compose up --build -d
```

### Step 4. Once it's started, you can check multiple endpoints via your browser

Frontend - http://localhost/

![](/screenshots/do_2/frontend.png "frontend")

Backend - http://localhost/api/health

![](/screenshots/do_2/backend.png "backend")
</details>

## Instructions for task DO_4

<details>
<summary>Click to expand</summary>

### Step 1. Create a private ECR registry

1.1 Login to your AWS console and type `ECR` in a serach field, click on Elastic Container Registry to move to ECR console

![](/screenshots/do_4/ecr1.png "ecr")

1.2 Click `Get Started` CTA to create your first repository

![](/screenshots/do_4/ecr2.png "ecr")

1.3 We need a private repo so i kept `Private`, choose the name for your repo and turn the `Tag immutability` ON if you want to prevent image tags from being overwritten. I'll keep it default, since i don't need that option. Scroll down once you finished.

![](/screenshots/do_4/ecr3.png "ecr")

1.4 I'll keep `Image scan settings` and `Encryption settings` as it is. We can change it later if needed.

![](/screenshots/do_4/ecr4.png "ecr")

1.5 I created 3 separate repositories for `frontend images`, `backend images` and `nginx images` as per task requirements.

![](/screenshots/do_4/ecr5.png "ecr")

### Step 2. Create a Virtual Machine (EC2) with elastic IP

1.1 Login to your AWS console and type `EC2` in a serach field, click on EC2 to move to its console

![](/screenshots/do_4/vm1.png "ec2")

1.2 Click `Launch Instance` CTA to create your virtual machine

![](/screenshots/do_4/vm2.png "ec2")

1.3 Choose name for your instance and AMI with an operating system. I'll choose Amazon Linux for now and scroll down to continue.

![](/screenshots/do_4/vm3.png "ec2")

1.4 Click `Instance type` dropdown menu and choose proper instance for your purposes. Choose a `Key Pair` for your instance or create a new one clicking on `Create new key pair` in case you don't have it. Just follow the instructions provided by AWS. Once you finished, scroll down to Network settings.

![](/screenshots/do_4/vm4.png "ec2")

1.5 Once you get to `Network settings` you will be suggested to create security group for your instance OR select and existing one. In this lesson you could just create a new one and we will configure it later when we get to deploying our application. You also need to configure the size of your storage to meet your requirement. I extended mine to 12 gb just to make sure it's enough to meet my task's requirements. 

You don't need to configure `Advanced details` at this point. We will need to configure an IAM role for the instance, so we will get back to it during next steps. Click `Launch Instance` CTA.

![](/screenshots/do_4/vm5.png "ec2")

1.6 After a minute or so, it will appear on your `EC2 console`.

![](/screenshots/do_4/vm6.png "ec2")

### Step 3. Configure Elastic IP for our instance

1.1 We need to allocated an elastic ip for our instance, so taht it is available from the Internet, noit only inside our private VPC. Click on `Network & Security => Elastic IPs` on the left sidebar of the dashboard

![](/screenshots/do_4/ip1.png "ip")

1.2 Click `Allocate Elastic IP addres` on the right top of the screen

![](/screenshots/do_4/ip2.png "ip")

1.3 You can add tags if needed or just click `Allocate` CTA on the bottom of the form.

![](/screenshots/do_4/ip3.png "ip")

1.4 You'll be redirected to the console and find allocated ip in the list and you will also be suggested to assosiate your ip with your instance. You can either click `Associate the Elastic IP address` ot click `Actions => Associate Elastic IP address`.

![](/screenshots/do_4/ip4.png "ip")

1.5 Choose the instance you want your ip to be associated with from the dropdown menu and click `Associate` CTA on the bottom of the form. You can keep other settings as default.

![](/screenshots/do_4/ip5.png "ip")

1.6 You will see a success message which means your ip has been associated with your instance sucessfully. You can get back to the EC2 dashboard and check this once again.

![](/screenshots/do_4/ip6.png "ip")

1.7 You click `Instances` or `Instances (running)` (in ase you know your instance is currently running)

![](/screenshots/do_4/ip7.png "ip")

1.8 You can find your elastic ip on the instance information dashboard

![](/screenshots/do_4/ip8.png "ip")

### Step 4. Create roles for your services 


</details>