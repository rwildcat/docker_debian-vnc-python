# Debian-based basic python wokstation
# Updated on 2019-08-16
#
# R. Solano <ramon.solano@gmail.com>

FROM rsolano/debian-slim-vnc:10.0

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	\
	&& apt-get install -qy python ipython python-pip python-rope \
	python-numpy python-matplotlib python-pandas python-scipy python-plotly \
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

# a. plotply and vscode extensions
RUN pip install plotly \
	&& code --install-extension ms-python.python

# return to root
USER root

# ports (SSH, VNC, Jupyter)
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
