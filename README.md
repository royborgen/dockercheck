# Dockercheck 
This repository contains a shell script which connects to a multiple docker hosts via SSH and lists out all dangling (orphgan) container images. The script can also remove the unused images.

## Features
- Connects to remote docker hosts via SSH
- Executes `docker image ls` on each
- Displays results 
- Allows the user to delete orhan images (`prune`)
- When deleting images the script executes `docker image prune -f`

## Prerequisites

- SSH access to remote docker hosts
- User must have permissions to execute docker commands on the docker host. 

## Usage

1. **Clone the Repository**
   ```bash
    git clone https://github.com/royborgen/dockercheck.git
   ```

2. **Make the Script Executable**
   ```bash
   chmod +x dockercheck.sh
   ```
   
3. **Add hosts file container docker hosts**
The file should be called `hosts`. 
See `hosts.sample`for an example. 

3. **Run the Script**
   ```bash
    user@hostname:~$ dockercheck
    Checking for dangling docker images...

    host1.docker.example.com:
    jc21/nginx-proxy-manager          <none>    9f5e0949eb63   3 months ago    1.09GB
    containrrr/watchtower 	           <none>    e7dd50d07b86   3 months ago    14.7MB

    host2.docker.example.com:
    pihole/pihole                     <none>    81365952d1f8   5 days ago      92.7MB

    host2.docker.example.com:
    No dangling image found
   ```
4. **Help text**
./dockercheck.sh --help to display help text
   ```bash
   Usage: dockercheck [OPTION]
   Performs SSH to host and checks for dangling docker images.

   Optional arguments:
   prune,             removed all dangling images on hosts
   -h, --help         displays this message

   ```


## License

This project is open source, licensed under the GPL-2.0 license. See the projects `LICENSE` file for details.
