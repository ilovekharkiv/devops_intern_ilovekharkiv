# Instructions for task DO_1

## Step 1. Download the repository with Dockerfile 

Click this [Link](https://github.com/ilovekharkiv/devops_intern_ilovekharkiv/archive/refs/heads/DO_1.zip). Once it is downloaded, locate it on your computer and open the terminal form repo's root folder. You will find the files that you need for launching the script.


## 2. Rename .env.sample => .env

You will find .env.sample inside the repo and you need ti rename it to `.env`. The content of the file is the following:

```bash
REPO_SSH_URL="git@github.com:ilovekharkiv/devops_intern_ilovekharkiv.git"
BACKUP_DIR=backup
REPO_NAME="git@github.com:ilovekharkiv"
MAX_BACKUPS=3 # You need to choose the amount of backups you would like to generate. Please keep in mind that MAX_BACKUPS has to be >0, otherwise backup won't be created
RUN_AMOUNT=5  # This is the amount of runs, which script will do before it stops
DB_USER=
DB_PASSWORD=
DB_ENDPOINT=
DB_NAME=
```

## 3. Build an image

```bash
docker build -t my_backup .
```

## 4. Run the container

```
sudo docker run -it \
-v $(pwd)/backup:/backup \
-v $SSH_AUTH_SOCK:/ssh-agent \
-e SSH_AUTH_SOCK=/ssh-agent \
my_backup
```

