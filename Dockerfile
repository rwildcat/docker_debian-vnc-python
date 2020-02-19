
# Debian-based basic python wokstation
# Updated on 2020-01-19
#
# R. Solano <ramon.solano@gmail.com>

FROM rsolano/debian-slim-vnc:10.2

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -q update \
	&& apt-get -qy upgrade \
	&& apt-get install -qy \
	# python2
		python ipython python-pip \
		python-numpy python-matplotlib python-pandas python-scipy \
		python-plotly python-notebook spyder \
		jupyter-notebook  firefox-esr \
	# python3
		python3 python3-ipython python3-pip \
		python3-numpy python3-matplotlib python3-pandas python3-scipy \
		python3-plotly python3-notebook spyder3  \
	# vscode
	&& apt-get install -qy wget gnupg \
	&& wget -q -O /tmp/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868 \
	&& dpkg -i /tmp/vscode.deb \
	# cleanup
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* 

# personal stuff
USER debian

# vscode extensions, ipython3 alias
RUN code --install-extension ms-python.python \
	&& echo "alias ipython3='python3 -m IPython'" >> /home/debian/.bashrc 

# return to root
USER root

# ports (SSH, VNC, Jupyter)
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
