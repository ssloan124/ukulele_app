FROM rocker/tidyverse

COPY ./mountpoints/apps/. /srv/shiny-server

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y software-properties-common
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
 git \
 git-lfs \
 make \
 gzip \
 rename

RUN  add-apt-repository -y ppa:ubuntu-toolchain-r/test \
  && apt-get update -y  --allow-unauthenticated \
  && apt-get install -y libxml2-dev libpoppler-cpp-dev libapparmor-dev \
     gfortran gcc-7 g++-7 libx11-dev libglu1-mesa-dev libfreetype6-dev \ 
     libxml2-dev libgmp-dev glpk-utils libtiff-dev libfftw3-dev libfftw3-doc\
  && apt-get install -y r-cran-igraph r-cran-rglpk

RUN Rscript -e 'install.packages(c("mvtnorm", "matrixcalc", "igraph", "gplots", "Matrix"))'

RUN install2.r --error \
    lubridate \
    reticulate \
    imager

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

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget


# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('shiny', 'rmarkdown'))" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    chown shiny:shiny /var/lib/shiny-server

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]





