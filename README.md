# Dockercheck 
This repository contains a shell script which connects to a multiple docker hosts via SSH and lists out all dangling (orpgan) container images. The script can also remove the unused images.

## Features
- SSH to multiple docker hosts
- Executes `docker image ls` on each
- Displays results 
- Allows the user to delete orhan images (`prune`)
- When deleting images the script executes `docker image prune -f`

## Prerequisites

- User with SSH access to remote docker hosts
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
   ./dockercheck.sh
   ```

## License

This project is open source, licensed under the GPL-2.0 license. See the projects `LICENSE` file for details.
