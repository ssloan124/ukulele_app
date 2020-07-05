FROM rocker/tidyverse

RUN apt-get update && apt-get upgrade -y

COPY ./mountpoints/apps/. /srv/shiny-server

RUN install2.r --error \
    lubridate \
    reticulate

RUN export ADD=shiny && bash /etc/cont-init.d/add

# install python3, virtualenv and anaconda

RUN apt-get update && apt-get install -y \
        python3 \
        python3-dev \
		python3-pip \
	&& pip3 install virtualenv

# install anaconda

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-4.3.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH



