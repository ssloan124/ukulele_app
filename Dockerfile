FROM rocker/tidyverse

RUN apt-get install -y --fix-missing libfftw3-dev libx11-dev libtiff-dev

RUN install2.r --error \
    lubridate \
    reticulate 
#\
#    imager

RUN export ADD=shiny && bash /etc/cont-init.d/add



#RUN apt-get update --fix-missing \
#	&& apt-get install -y \
#		ca-certificates \
#   	        libglib2.0-0 \
#	 	libxext6 \
#	   	libsm6  \
#	   	libxrender1 \
#		libxml2-dev

#RUN apt-get update -y && \
#    apt-get install -y --no-install-recommends \
#            python3-dev \
#            python3-pip \
#            python3-tk \
#            python3-setuptools \
#            python3-wheel && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*

#RUN pip3 install music




