# Debian-based basic python wokstation
# Updated on 2019-05-20
# R. Solano <ramon.solano@gmail.com>

FROM rsolano/debian-slim-vnc:9.9

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	\
	&& apt-get install -qy python ipython python-pip python-rope \
	python-numpy python-matplotlib python-pandas python-scipy \
	jupyter-notebook jupyter-nbextension-jupyter-js-widgets \
	spyder firefox-esr \
	\
	# install vscode
	&& apt-get install -qy wget gnupg \
	&& wget -q -O /tmp/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868 \
	&& dpkg -i /tmp/vscode.deb \
	\
	# cleanup
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* 


# personal stuff
USER debian

# a. vscode extensions
RUN code --install-extension ms-python.python

# return to root
USER root

# ports (SSH, VNC, Jupyter)
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
