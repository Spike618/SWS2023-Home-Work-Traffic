# SWS2023-Home-Work-Traffic
NUS SWS2023 Cloud computing with big data project


## CV model ##
### model ###
- use yolov5 to find the cars in the road
- use the VisDrone datasets and self-labeled datasets to train our model

### performance ###
![image](https://github.com/Spike618/SWS2023-Home-Work-Traffic/assets/81232694/0caedfb7-ef54-455c-a8cb-1242936564a2)
`details are in file:` [CVresults]([https://github.com/Spike618/SWS2023-Home-Work-Traffic/edit/master/README.md](https://github.com/Spike618/SWS2023-Home-Work-Traffic/tree/master/CVresult))



## deployment ###

### EC2 ###
- upload our model to the EC2
- use flask to run our model on the server, and receive the request
- use boto3 to send the result to the AWS S3

### EMR ###
- configure enviroment using bootstrap action script
- upload files to cluster from S3 bucket
- deploy pyspark program
