#!/bin/bash

service ssh start

INTERVAL=100000
while true;
do
    ps x;
    sleep $INTERVAL;
done