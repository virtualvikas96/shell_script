#!/bin/bash

#Function to display usage instruction and prompt for user input

display_menu() {
echo "Docker Container Management Script"
echo
echo "Please choose an option:"
echo
echo "Commands:"
echo "1. start stoped containers"
echo "2. Stop running containers"
echo "3. Remove unused containers"
echo "4. Rebuild Docker images "
echo "5. Prune unused images, volumes, containers"
echo "6. Monitor snd restart unhealty containers"
echo "7. Manually restart unhealty containers"
echo "8. Exit"
echo
read -p "Enter your choice (1-8): " choice

}

#Start stopped containers
start_containers() {
    stopped_containers=$(docker ps -a -q -f "status=exited")
    if [ -z "$stopped_containers" ]; then
        echo "No stopped containers to start."
    else
        echo "Starting stopped containers..."
        docker start $stopped_containers
        echo "Started containers: $stopped_containers"
    fi
}


#Stop started continers
stop_containers(){
	running_containers=$(docker ps -q)
	if [ -z "$running_containers"]; then
	    echo "No running container to stop"
	else
	    echo "Stopping running containers..."
	    docker stop $running_containers
		echo "Stopped Containers: $running_containers"
	fi
}


#Remove unsed containers
remove_containers(){
	unused_containers=$(docker ps -a -q -f "status=exited")
	if [ -z "$unsed_containers"]; then
		echo "No unsed conatiners to remove"
	else
		echo "Removing unsed conatiners..."
		docker rm $unsed_containers
		echo "Unsed containers removed"
	fi
}


# Rebuild docker images
rebuild_images(){
	echo "Rebuilding Docker images..."
	docekr-compose build --no-cache
	echor "rebuild complete"
}


#Prune unsed images, containers and volumes
prune_docker(){
	echo "Pruning unsed images, conatiners and volumes..."
	docker system prune -af
	docker volume prune -f
	echo "Prune complete"

}


#Monitor and restart unhealty containers
monitor(){
	unhealty_containers=$(docker ps --filter "health=unhealthy" --format "{{.ID}}" )
	if [ -z "$unhealty_containers"]; then
		echo "No unhealty conatiners found"
	else
		echo "Restarting unhealty conatiners..."
		for container in $unhealty_containers; do
			echo "Restarting containers: $container"
		docker restart $container
	done
	echo "Restarted unhealty containers: $unhealty_containers"
	fi

}



#Manulally restarting unhealty containers
restart_unhealty(){
	echo "Manually restarting unhealty containers..."
	monitor

}



#Main logic to handle uner input and run the choosen command


while true; do
	display_menu
	case "$choice" in
		
		1)
			start_containers
			;;
		2)
			stop_containers
			;;
		3)
			remove_containers
			;;
		4)
			rebuild_images
			;;
		5)
			prune_docker
			;;
		6)
			monitor
			;;
		7)
			restart_unhealty
			;;
		8)
			echo "Exiting script"
			exit 0
			;;
		*)
			echo "Inavlid option, please try agin"
			;;

	esac
	echo
done	

