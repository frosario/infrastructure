#!/bin/bash
source /source-vars.sh  &&\
cd $GRITS_HOME/grits-api &&\
exec $GRITS_HOME/grits_env/bin/celery worker -A tasks -Q priority --loglevel=INFO --concurrency=$PRIORITY_WORKERS
