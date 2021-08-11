# Docker

Your VM is a Debian 10

Install Docker
---------------
* Update the apt package index and install packages to allow apt to use a repository over HTTPS:
```bash
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

```
* Add Docker’s official GPG key:
```bash
 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
* Use the following command to set up the stable repository.
```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
* install the latest version of Docker Engine and containerd
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Try Docker
-----------
* Run Docker as root:
```bash
sudo docker run hello-world
```
* Run Docker (as a regular user):
```bash
$ docker run hello-world
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.27/images/json: dial unix /var/run/docker.sock: connect: permission denied
```
* You need to be a member of the docker group:
```bash
$ sudo groupadd docker
$ sudo usermod -aG docker debian
$ exit
$ ssh -i nrec.pem debian@<IP-Address>
```
* Now you can use docker:
```bash
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
78445dd45222: Pull complete
Digest: sha256:c5515758d4c5e1e838e9cd307f6c6a0d620b5e07e6f927b07d05f6d12a1ac8d7
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```
* [Official page](https://docs.docker.com/engine/install/debian/)

Here we go... Part 1 (Basics)
------------------------------
1. [Run your first container](http://training.play-with-docker.com/ops-s1-hello/)
2. [Docker images](http://training.play-with-docker.com/ops-s1-images/)
3. [Docker volumes](http://training.play-with-docker.com/docker-volumes/)
4. [Advanced example - 30 mins](http://training.play-with-docker.com/beginner-linux/)

Part 2 (Container Service with Docker compose)
------------------------------------------------
5. [Docker Compose - 120 mins](https://github.com/abdulrahmanazab/docker-training-neic/blob/prace-training-2021/docker-compose.md)

Part 3 (Distributed orchestration with Swarm)
----------------------------------------------
6. [Introduction to Docker swarm - 16 mins video](https://www.youtube.com/watch?v=Tm0Q5zr3FL4)
7. [Docker swarm](http://training.play-with-docker.com/swarm-mode-intro/)
8. [Swarm Mode Introduction for IT Pros](http://training.play-with-docker.com/ops-s1-swarm-intro/)
9. [Docker orchestration with swarm - 30 mins](https://training.play-with-docker.com/orchestration-hol/)

Backup:
--------
10. Docker continuous integration ([Slides](https://github.com/abdulrahmanazab/docker-training-neic/blob/research-bazaar-2020/Docker-continous-integration.pdf)), ([exercise](https://github.com/abdulrahmanazab/docker-training-neic/blob/research-bazaar-2020/docker-continuous-integration.md))
11. [Docker with user namespaces](https://github.com/abdulrahmanazab/docker-training-neic/blob/research-bazaar-2020/docker-userns.md)

