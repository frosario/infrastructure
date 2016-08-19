FROM ubuntu:14.04.4

#Install dependencies
#Chaining these commands to keep the image smaller
RUN apt-get clean all && \
    apt-get update && \
    apt-get -y install build-essential openssh-server python python-dev python-setuptools python-pip mongodb-clients mongodb python-software-properties debconf-utils software-properties-common curl libffi-dev libssl-dev acl git make && \
    pip install virtualenv virtualenvwrapper awscli && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean all

RUN pip install --upgrade setuptools
RUN pip install ansible

# Install mongodb clients
RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update && apt-get -y install mongodb-clients
RUN apt-get clean all

COPY promed_mail_scraper /promed_mail_scraper

# Create cronjob to run ProMED mail ingest
ADD crontab /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

RUN mkdir /shared

ADD cronjob.sh /cronjob.sh

VOLUME /shared
EXPOSE 80
COPY run.sh /run.sh
CMD bash run.sh