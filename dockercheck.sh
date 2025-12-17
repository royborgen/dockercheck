#!/bin/bash

#name of the hosts-file
host_file="hosts"

#setting text color
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

# To ensure the script works with bash aliases, we fetch the full path to host_file
path_host_file="$(cd "$(dirname "$0")" && pwd)/$host_file"

# Check if the hosts file exists
if [ ! -f "$path_host_file" ]; then
    echo "ERROR! Unable to read the file '$host_file'..."
    echo "This file needs to exist in the scripts execution directory and"
    echo "should contain a list of docker hosts. The executing user must have"
    echo "read permissions to this file."
    exit 1
else 
    hosts=$(cat $path_host_file)
fi

#checking argumens and provides help text
if [ $# -ne 0 ]; then
    if [ $1 = "-h" ] || [ $1 = "--help" ]; then
        echo "Usage: dockercheck [OPTION]"
        echo "Performs SSH to host and checks for dangling docker images."
        echo ""
        echo "Optional arguments:"
        echo "prune,             removed all dangling images on hosts"
        echo "-h, --help         displays this message"
        echo ""
        exit
    fi
    
    #if argument "prune" is provided, we remove all unused docker images on each host
    if [ "$1" = "prune" ]; then
        echo "Removing dangling docker images..."
        echo ""
        for host in $hosts; do
            echo -e "${CYAN}$host:${NOCOLOR}"
            output=$(ssh "$host" 'docker image prune -f')

            if [ -z "$output" ]; then
                echo "Could not remove images"
            else
                echo "$output"
            fi
    
            echo ""
        done 
    else
        echo "ERROR: Unsupported argument '$1'."
        echo "Please use -h or --help to display usage instructions and valid options."
        echo ""
        exit
    fi
fi

#if no argument is provided, we fetch all dangling docker images 
if [ "$1" != "prune" ]; then
    echo "Checking for dangling docker images..."
    echo ""

    for host in $hosts; do
        echo -e "${CYAN}$host:${NOCOLOR}"
        output=$(ssh "$host" "docker images -a --format 'table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}' | grep none")

        if [ -z "$output" ]; then
            echo "No dangling image found"
        else
            # Loop through all lines in output
            echo "$output" | while read -r line; do
                container_name=$(echo "$line" | awk '{print $1}')
                
                if [ "$container_name" = "<none>" ]; then
                    container_id=$(echo "$line" | awk '{print $3}')
                    container_name=$(ssh "$host" "docker ps -q -f name=watchtower >/dev/null && docker logs watchtower 2>&1 | grep \"$container_id\" | tail -n1 | sed -E 's/.*Found new ([^:]+):.* image.*/\1/'")

                    if [ "$container_name" ]; then
                        output=$(echo "$line" | awk -v name="$container_name" '{ print name "\t\t" $3 "\t" $4 " " $5 " " $6 "\t" $7}')
                        echo "$output"
                    else
                        output=$(echo "$line" | awk '{ print $1 "\t\t" $3 "\t" $4 " " $5 " " $6 "\t" $7}')
                        echo "$output"
                    fi
                else
                    output=$(echo "$line" | awk '{ print $1 "\t\t" $3 "\t" $4 " " $5 " " $6 "\t" $7}')
                    echo "$output"
                fi
            done
        fi

        echo ""
    done
fi

