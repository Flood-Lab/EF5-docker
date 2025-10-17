#A Docker for The Ensemble Framework For Flash Flood Forecasting (EF5)

FROM ubuntu 

LABEL name="Stand-Alone EF5"
LABEL description="This container runs an image of the Ensemble Framework For Flash Flood Forecasting (EF5)."
LABEL version="0.2"

MAINTAINER Zhi Li <Zhi.Li-2@colorado.edu>

RUN apt-get update

# Install software 
RUN apt-get install -y \
	git

RUN apt-get install -y \
        gcc \
	build-essential \
	make \
	libgeotiff-dev \
	dh-autoreconf

RUN git clone https://github.com/HyDROSLab/EF5.git
RUN cd EF5 && autoreconf --force --install
RUN cd EF5 && ./configure
RUN cd EF5 && make