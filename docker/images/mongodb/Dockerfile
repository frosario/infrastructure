FROM ubuntu:14.04.3

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install mongodb
RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get -y install mongodb
RUN apt-get clean all

# Create an indicator if an external volume is not mounted.
# This is important becuase we do not want the data files to
# reside inside of the actual container.
RUN rm -fr /var/lib/mongodb/*
RUN touch /var/lib/mongodb/NOT-MOUNTED
RUN touch /var/log/NOT-MOUNTED

LABEL app="mongodb"
EXPOSE 27017

# Add config files and scripts
ADD mongodb.conf /etc/mongodb.conf
Add run.sh /run.sh

CMD /bin/bash run.sh