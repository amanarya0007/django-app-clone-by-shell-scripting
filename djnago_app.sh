#!/bin/bash

#Djangi app deployement

code_clone(){
        echo "Cloning the django app..."
        if [ -d "django-notes-app" ];then
                echo "The code directory already exits. Skipping the clone"
        else
        git clone https://github.com/LondheShubham153/django-notes-app.git || {
                echo "Failed to clone the code"
        return 1
}
        fi
}

install_requirements(){
        echo "installing the required softwares..."
        sudo apt-get update && sudo apt-get install -y nginx docker.io docker-compose || {
                echo "Faild to install the required softwares."
        return 1
}
}

required_restarts(){
        echo "performing the restart to built the django app..."
        sudo chown "$USER" /var/run/docker.sock || {
                echo "Failed to change the ownership of docker.sock"
        return 1
}
        sudo systemctl enable docker
        sudo systemctl enable nginx
        sudo systemctl restart docker
}

deploy(){
        echo "Finally deploying the app..."
        docker build -t notes-app . && docker compose up -d || {
                echo "Failed to built and deploy the app"
        return 1
}
}


echo "******** DEPLOYEMENT STARTED ********"

if code_clone; then
        cd django-notes-app || exit 1
else
        exit 1
fi

if ! install_requirements; then
        exit 1
fi

if ! required_restarts; then
        exit 1
fi

if ! deploy; then
        exit 1
fi

echo "******** DEPLOYEMENT DONE ********"
