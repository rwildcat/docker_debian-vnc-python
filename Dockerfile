# Debian-based basic python wokstation
# Updated on 2019-05-01
# R. Solano <ramon.solano@gmail.com>

FROM rsolano/debian-slim-vnc

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update -q \
	&& apt-get install -qy python ipython python-numpy \
	python-matplotlib python-pandas python-scipy \
	spyder jupyter-notebook jupyter-nbextension-jupyter-js-widgets python-rope firefox-esr \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# add local config files
ADD etc /etc

# ports (SSH, VNC, Jupyter)
EXPOSE 22 5900 8888

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
