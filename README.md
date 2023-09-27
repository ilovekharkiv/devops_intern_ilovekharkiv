# Task 1 DevOps 1.0

## Table of Contents
#### [1. Instructions for task DO_1](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/tree/DO_2#instructions-for-task-do_1)
#### [2. Instructions for task DO_2](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/tree/DO_2#instructions-for-task-do_2)
#### [3. Instructions for task DO_3]()


## Instructions for task DO_1

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

## Instructions for task DO_2

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