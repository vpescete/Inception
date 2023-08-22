#!/bin/bash

command="$@"
$command 2>&1 | awk '/^(Step [0-9]+\/[0-9]+ : (FROM|CMD|RUN|COPY|ENTRYPOINT)|Building)/ {
    if ($1 == "Building") {
        service_name=$2
        service_line=$0
    } else {
        split($0, parts, " | ")
        step_info=parts[3]
        step_number=$2  # Extract the step number
        command_type=parts[5]  # Extract the command type
        
        # Define colors for different services
        service_color="\033[0m"  # Default color
        if (service_name == "mariadb") {
            service_color="\033[31m"  # Red color
        } else if (service_name == "wordpress") {
            service_color="\033[32m"  # Green color
        } else if (service_name == "nginx") {
            service_color="\033[34m"  # Blue color
        } else if (service_name == "dependency") {
            service_color="\033[34m"  # Blue color
            service_name="nginx"
        }
        
        if (service_line) {
            if (command_type == "Building") {
                printf "\033[1m| %s%s \033[1m|\033[0m %s porcoddio \n", service_color, service_name, service_line
            } else {
                printf "\033[1m| %s%s \033[0m\033[1m|\033[0m %s\n", service_color, service_name, service_line, step_info
            }
            service_line=""
        }
        else {
            if (command_type == "RUN" || command_type == "CMD" || command_type == "COPY") {
                printf "\033[1m| %s%s \033[1m|\033[0m Step %s/%s : %sdioporco\n", service_color, service_name, step_number, parts[4], command_type
            } else {
                printf "\033[1m| %s%s \033[0m\033[1m|\033[0m Step %s : %s\n", service_color, service_name, step_number, parts[4]
            }
        }
    }
}'
