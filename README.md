# Debian Python

A basic [Debian](https://hub.docker.com/_/debian)-based personal Python workstation. Provides Python + basic engineering modules, Jupyter Notebook, Spyder IDE, Visual Studio Code, and SSH.

Based on [rsolano/debian-slim-vnc](https://hub.docker.com/r/rsolano/debian-slim-vnc) image.

*Ramon Solano <<ramon.solano@gmail.com>>*

**Last update:** May/21/2019
**Debian version:** 9.9

## Main packages

* VNC, SSH (Inherited from rsolano/debian-slim-vnc)
* Python[2,3]
* Modules: Numpy, Matplotlib, Pandas, SciPy
* IPython
* Jupyter Notebook
* Spyder IDE
* MS VS Code
* Firefox

## Users

User/pwd:

* root/debian
* debian/debian (sudoer)

## To build from `Dockerfile`

```sh
$ docker build -t rsolano/debian-vnc-python .
```

## To run container

```sh
$ docker run [-it] [--rm] [--detach] [-h HOSTNAME] [-p LVNCPORT:5900] [-p LSSHPORT:22] [-p LNOTEBOOKPORT:8888] [-v LDIR:DIR] [-e XRES=1280x800x24] rsolano/debian-vnc-python
```

where:

* `LVNCPORT`: Localhost VNC port to connect to (e.g. 5900 for display :0).

* `LSSHPORT`: local SSH port to connect to (e.g. 2222, as *well known ports* (those below 1024) may be reserved by your system).

* `XRES`: Screen resolution and color depth.

* `LNOTEBOOKPORT`: Local HTTP Jupyter Notebook port to connecto to (e.g. 8888). Requires IP=0.0.0.0 when running Jupyter in your container for connecting from your locahost, otherwise IP=127.0.0.1 for internal access only.

* `LDIR:DIR`: Local directory to mount on container. `LDIR` is the local directory to export; `DIR` is the target dir on the container.  Both sholud be specified as absolute paths. For example: `-v $HOME/worskpace:/home/debian/workspace`.

### Examples

* Run container, keep terminal open (interactive terminal session); remove container from memory once finished the container; map VNC to 5900 and SSH to 2222, no Jupyter Notebooks:

	```sh
	$ docker run -it --rm -p 5900:5900 -p 2222:22 rsolano/debian-vnc-python
	```

* Run image, keep terminal open (interactive terminal session); remove container from memory once finished the container; map VNC to 5900 and SSH to 2222, map Jupyter Notebooks to 8888; mount local `$HOME/workspace` on container's `/home/debian/workspace`:

	```sh
	$ docker run -it --rm -p 5900:5900 -p 2222:22 -p 8888:8888 -v $HOME/workspace:/home/debian/workspace rsolano/debian-vnc-python
	```

* Run image, keep *console* open (non-interactive terminal session); remove container from memory once finished the container; map VNC to 5900 and SSH to 2222, map Jupyter Notebooks to 8888:

	```sh
	$ docker run --rm -p 5900:5900 -p 2222:22  -p 8888:8888 rsolano/debian-vnc-python
	```

* Run image, detach to background and keep running in memory (control returns to user immediately); map VNC to 5900 and SSH to 2222; map Jupyter Notebooks to 8888; change screen resolution to 1200x700x24

	```sh
	$ docker run --detach -p 5900:5900 -p 2222:22 -p 8888:8888 -e XRES=1200x700x24 rsolano/debian-vnc-python
	```

**NOTES**

* Some graphical programs such as Firefox and Spyder can run by copying their corresponding icons from the `/usr/share/applications` to your desktop.

* Alternatively, you can find all your installed graphical applications from the `Application Finder` Panel dock (located just before your home folder icon).

## To stop container

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