#!/bin/bash

aws s3 cp s3://emr-vision-model/dependencies/best.pt / 
aws s3 cp s3://emr-vision-model/dependencies/count_vehicles.py /
aws s3 cp s3://emr-vision-model/dependencies/export.py / 
aws s3 cp s3://emr-vision-model/dependencies/models/ / --recursive 
aws s3 cp s3://emr-vision-model/dependencies/utils/ / --recursive 
