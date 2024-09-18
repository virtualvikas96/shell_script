#!/bin/bash

# Function to display usage instructions and prompt for user input
display_menu() {
    echo "Docker Container Management Script"
    echo
    echo "Please choose an option:"
    echo "1. Start stopped containers"
    echo "2. Stop running containers"
    echo "3. Remove unused containers"
    echo "4. Rebuild Docker images"
    echo "5. Prune unused images, containers, and volumes"
    echo "6. Monitor and restart unhealthy containers"
    echo "7. Manually restart unhealthy containers"
    echo "8. Exit"
    echo
    read -p "Enter your choice (1-8): " choice
}

# Start stopped containers
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

# Stop running containers
stop_containers() {
    running_containers=$(docker ps -q)
    if [ -z "$running_containers" ]; then
        echo "No running containers to stop."
    else
        echo "Stopping running containers..."
        docker stop $running_containers
        echo "Stopped containers: $running_containers"
    fi
}

# Remove unused containers
remove_containers() {
    unused_containers=$(docker ps -a -q -f "status=exited")
    if [ -z "$unused_containers" ]; then
        echo "No unused containers to remove."
    else
        echo "Removing unused containers..."
        docker rm $unused_containers
        echo "Removed containers: $unused_containers"
    fi
}

# Rebuild Docker images
rebuild_images() {
    echo "Rebuilding Docker images..."
    docker-compose build --no-cache
    echo "Rebuild complete."
}

# Prune unused images, containers, and volumes
prune_docker() {
    echo "Pruning unused Docker resources..."
    docker system prune -af
    docker volume prune -f
    echo "Prune complete."
}

# Monitor and restart unhealthy containers
monitor_unhealthy_containers() {
    unhealthy_containers=$(docker ps --filter "health=unhealthy" --format "{{.ID}}")

    if [ -z "$unhealthy_containers" ]; then
        echo "No unhealthy containers found."
    else
        echo "Restarting unhealthy containers..."
        for container in $unhealthy_containers; do
            echo "Restarting container: $container"
            docker restart $container
        done
        echo "Restarted unhealthy containers: $unhealthy_containers"
    fi
}

# Manually restart unhealthy containers
restart_unhealthy_containers() {
    echo "Manually restarting unhealthy containers..."
    monitor_unhealthy_containers
}

# Main logic to handle user input and run the chosen command
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
            monitor_unhealthy_containers
            ;;
        7)
            restart_unhealthy_containers
            ;;
        8)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done

