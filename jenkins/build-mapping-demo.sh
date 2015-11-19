#!/bin/bash
#Name: build-mapping-demo.sh
#Purpose: Shell script that jenkins will use to build docker container to demo mapping engine build by DIT
#Author: Freddie Rosario <rosario@ecohealthalliance.org>

#Checkout necessary repos
mkdir -p example/packages
cd example/packages
rm -fr grits-net-meteor grits-net-mapper grits-net-consume
git clone git@github.com:ecohealthalliance/grits-net-meteor.git
git clone git@github.com:ecohealthalliance/grits-net-mapper.git
git clone git@github.com:ecohealthalliance/grits-net-consume.git


#Build the meteor app
cd ../
source /var/lib/jenkins/.profile 
nvm use v0.12.7
rm -fr ./gritsbuild
meteor build ./gritsbuild --directory || exit 1


#Create the docker file
touch ./gritsbuild/bundle/Dockerfile
cat > ./gritsbuild/bundle/Dockerfile<<-EOF
FROM node:0.12
EXPOSE 80
ADD . .
RUN apt-get update && apt-get -y install build-essential python python-dev python-setuptools python-pip
RUN pip install virtualenv virtualenvwrapper
RUN cd programs/server && npm install
CMD bash run.sh
EOF


#Create run.sh
touch ./gritsbuild/bundle/run.sh
cat > ./gritsbuild/bundle/run.sh<<-EOF
virtualenv grits-net-consume-env &&\
source grits-net-consume-env/bin/activate &&\
pip install -r requirements.txt

python grits_flight_pull.py
python grits_consume.py --type DiioAirport tests/data/MiExpressAllAirportCodes.tsv
python grits_consume.py --type FlightGlobal tests/data/GlobalDirectsSample_20150728.csv

node main.js
EOF

#Build the example app container
cp -R ./packages/grits-net-consume/*.py ./packages/grits-net-consume/requirements.txt ./gritsbuild/bundle/
docker build -t grits-net-meteor ./gritsbuild/bundle/


