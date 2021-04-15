# Debian VNC+Python

A *graphical* [Debian](https://hub.docker.com/_/debian)-based personal Python workstation. Provides **VNC**, **SSH**, **Python** w/ basic engineering modules, **Jupyter Notebook**, **Spyder IDE** and **Visual Studio Code**.

Based on the [rsolano/debian-slim-vnc](https://hub.docker.com/r/rsolano/debian-slim-vnc) image.

**Last update:** Apr/14/2021  
**Debian version:** 10.9

## Main packages

* **VNC**, **SSH** (Inherited from [rsolano/debian-slim-vnc](https://hub.docker.com/r/rsolano/debian-slim-vnc))
* **Python2**, **Python3**
	* Modules: `Numpy`, `Matplotlib`, `Pandas`, `SciPy`, `Plotly`
* **IPython** (Python2, Python3)
* **Jupyter Notebook** (Python2, Python3)
* **Spyder IDE** (Python2, Python3)
* **MS Visual Studio Code** (w/ Python extension)
* **Firefox**

## Users

| User | Password|
| --- | --- |
| root | debian |
| debian | debian (sudoer) |


## Usage (synopsis)

Usage is split in two main sections:

* Docker image usage
* Python usage


### Docker image usage

1. Download (*pull*) the image from its [docker hub repository](https://cloud.docker.com/u/rsolano/repository/docker/rsolano/debian-vnc-python) (optional):
   
	```sh
	$ docker pull rsolano/debian-vnc-python
	```
   

2. Run the container (the image will be *pulled* first if not previously downloaded).

	For example:

	* To run an ephemeral VNC session (port 5900):

		```sh
	   $ docker run --rm -p 5900:5900 rsolano/debian-slim-vnc
	   ```
	   
	* To run an ephemeral VNC + SSH session (port 5900 and 2222):

		```sh
	   $ docker run --rm -p 5900:5900 -p 2222:22 rsolano/debian-slim-vnc
	   ```

	* To run an ephemeral VNC + SSH session, and mounting my personal `$HOME/Documents` directory into remote `/Documents` :

		```sh
	   $ docker run --rm -p 5900:5900 -p 2222:22 -v $HOME/Documents:/Documents rsolano/debian-slim-vnc
	   ```

	* To run a Jupyter Notebook server -only session, delete image from memory once finished session and mount the current dir into `/notebooks` on server:

		```sh
		$ docker run -it --rm -p 8888:8888 -v `pwd`:/notebooks rsolano/debian-vnc-python jupiterd.sh /notebooks
		```
		
		Notice that in order to start the Jupyter server, we run the command 
		
		~~~sh
		... jupiterd.sh [<dir>]
		~~~
		
		where `dir` is the inital directory Jupyter show as current (default: `/`). In the above example:
		
		~~~sh
		... jupiterd.sh /notebooks
		~~~
		
		the initial directory is `/notebooks`.
		
		Once runnning:

		* Connect your web browser to `http://localhost:8888` and provide the given `token`.
		* Session will end when the Jupyter session ends or press keys `CTRL-C`.

	* To run an ephemeral VNC session and mount local `$HOME/notebooks` onto container's `/jnbs`:

		```sh
		$ docker run --rm -p 5900:5900 -v $HOME/notebooks:/jnbs rsolano/debian-vnc-python
		```

3. Use a VNC Viewer (such as the [RealVNC viewer](https://www.realvnc.com/en/connect/download/viewer/)) to connect to the host server (usually the `localhost`), port 5900:

	```
	localhost:5900
	```

### Programs usage

**Python**

| Program  | Python2      | Python3      |
| -------- | :----------- | :----------- |
| Python  | `$ python2`   | `$ python3`  |
| IPython  | `$ ipython2` | `$ ipython3` |
| Spyder   | `$ spyder`   | `$ spyder3`  |
| PIP      | `$ pip2`     | `$ pip3`     |


**Jupyter Notebook**

| Mode | Command |
| ---- | ------- |
| Local usage (localhost) | `$ jupyter-notebook --ip 127.0.0.1` |
| Public usage (network): | `$ jupyter-notebook --ip 0.0.0.0`   |

&nbsp;
## To build the image from the `Dockerfile` (optional, for Dockerfile developers)

If you want to customize the image or use it for creating a new one, you can download (clone) it from the [corresponding github repository](https://github.com/rwildcat/docker_debian-vnc-python). 

```sh
# clone git repository
$ git clone https://github.com/rwildcat/docker_debian-vnc-python.git

# build image
$ cd docker_debian-slim-vnc
$ docker build -t rsolano/debian-vnc-python .
```

&nbsp;
## Full syntax

```sh
$ docker run [-it] [--rm] [--detach] [-h HOSTNAME] [-p LVNCPORT:5900] [-p LSSHPORT:22] [-p LNOTEBOOKPORT:8888] [-v LDIR:DIR] [-e XRES=1280x800x24] [-e TZ={area/city}] rsolano/debian-vnc-python [CMD]
```

where:

* `LVNCPORT`: Localhost VNC port to connect to (e.g. 5900 for display :0).

* `LSSHPORT`: local SSH port to connect to (e.g. 2222, as *well known ports* (those below 1024) may be reserved by your system).

* `XRES`: Screen resolution and color depth.

* `LNOTEBOOKPORT`: Local HTTP Jupyter Notebook port to connecto to (e.g. 8888). Requires IP=0.0.0.0 when running Jupyter in your container for connecting from your locahost, otherwise IP=127.0.0.1 for internal access only.

* `LDIR:DIR`: Local directory to mount on container. `LDIR` is the local directory to export; `DIR` is the target dir on the container.  Both sholud be specified as absolute paths. For example: `-v $HOME/worskpace:/home/debian/workspace`.

* `TZ`: Local Timezone area/city, e.g. `Etc/UTC`, `America/Mexico_City`, etc. Default: `Etc/UTC`

* `CMD`: Command to run. For example, `jupiterd.sh`

&nbsp;
## To run a ***secured*** VNC session

This container is intended to be used as a *personal* graphic workstation, running in your local Docker engine. For this reason, no encryption for VNC is provided. 

If you need to have an encrypted connection as for example for running this image in a remote host (*e.g.* AWS, Google Cloud, etc.), the VNC stream can be encrypted through a SSH connection:

```sh
$ ssh [-p SSHPORT] [-f] -L 5900:REMOTE:5900 debian@REMOTE sleep 60
```
where:

* `SSHPORT`: SSH port specified when container was launched. If not specified, port 22 is used.

* `-f`: Request SSH to go to background afte the command is issued

* `REMOTE`: IP or qualified name for your remote container

This example assume the SSH connection will be terminated after 60 seconds if no VNC connection is detected, or just after the VNC connection was finished.

**EXAMPLES:**

* Establish a secured VNC session to the remote host 140.172.18.21, keep open a SSH terminal to the remote host. Map remote 5900 port to local 5900 port. Assume remote SSH port is 22:

	```sh
	$ ssh -L 5900:140.172.18.21:5900 debian@140.172.18.21
	```

* As before, but do not keep a SSH session open, but send the connecction to the background. End SSH channel if no VNC connection is made in 60 s, or after the VNC session ends:

	```sh
	$ ssh -f -L 5900:140.172.18.21:5900 debian@140.172.18.21 sleep 60
	```

Once VNC is tunneled through SSH, you can connect your VNC viewer to you specified localhot port (*e.g.* port 5900 as in this examples).



## To stop the container

* If running an interactive session:

  * Just press `CTRL-C` in the interactive terminal.

* If running a non-interactive session:

  * Just press `CTRL-C` in the console (non-interactive) terminal.


* If running *detached* (background) session:

	1. Look for the container Id with `docker ps`:   
	
		```
		$ docker ps
		CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                                          NAMES
		ac46f0cf41d1        rsolano/debian-vnc-python   "/usr/bin/supervisor…"   58 seconds ago      Up 57 seconds       0.0.0.0:5900->5900/tcp, 0.0.0.0:2222->22/tcp   wizardly_bohr
		```

	2. Stop the desired container Id (ac46f0cf41d1 in this case):

		```sh
		$ docker stop ac46f0cf41d1
		```

 ## Container usage
 
1. First run the container as described above.

2. Connect to the running host (`localhost` if running in your computer):

	* Using VNC (workstation general access): 

		Connect to specified LVNCPORT (e.g. `localhost:0` or `localhost:5900`)
		 
	* Using SSH: 

		Connect to specified host (e.g. `localhost`) and SSHPORT (e.g. 2222) 
		
		```sh
		$ ssh -p 2222 debian@localhost
		```
	* Using Web browser (Jupyter Notebook general access): 

		Connect to host computer (e.g. your localhost) and specified LVNCPORT (e.g. 8888):
		
		```http://localhost:8888```
