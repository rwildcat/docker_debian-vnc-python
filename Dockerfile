# Debian-based graphical Python wokstation
# Updated on 2021-04-14
#

FROM rsolano/debian-slim-vnc:10.9

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -q update \
	&& apt-get install -qy --no-install-recommends \
	# python2
	python ipython python-pip \
	python-numpy python-matplotlib python-pandas python-scipy \
	python-plotly python-notebook spyder \
	jupyter-notebook  firefox-esr \
	# python3
	python3 ipython3 python3-pip \
	python3-numpy python3-matplotlib python3-pandas python3-scipy \
	python3-plotly python3-notebook spyder3  \
	# vscode
	&& apt-get install -qy wget gnupg ca-certificates \
	libnss3 libsecret-1-0 libasound2 \
	&& wget -q -O /tmp/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868 \
	&& dpkg -i /tmp/vscode.deb \
	# cleanup
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* 

# add my config files
ADD Files/jupyterd.sh /usr/local/bin/jupyterd.sh

# user stuff
USER debian

# vscode extensions, ipython3 alias
RUN code --install-extension ms-python.python 

# return to root
USER root

# ports (SSH, VNC, Jupyter)
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
