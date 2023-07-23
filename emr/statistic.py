from pyspark.sql import SparkSession
import math
import requests
import json
import sys
import pandas as pd
from datetime import datetime
import boto3  # AWS SDK
from io import StringIO

sys.path.append("/usr/lib/spark/python/lib/")

from count_vehicles import my_count_vehicles

date_time = datetime.now().strftime('%Y-%m-%dT%H:%M:%S')
data_url = 'https://api.data.gov.sg/v1/transport/traffic-images/'
tomtom_url = 'https://api.tomtom.com/traffic/services/4/flowSegmentData/relative0/10/json/'

# 创建Spark上下文
spark = SparkSession.builder.appName("GetInformation").getOrCreate()

def tomtom_traffic(latitude, longitude):
    tomtom_params = {'point': '%s,%s' % (latitude, longitude),
                     'unit': 'KMPH',
                     'openLr': 'false',
                     'key': 'ze8YSxPAewmBAh4GbX0coKQz6Yuib3Bz'}
    tomtom_res = requests.get(url=tomtom_url, params=tomtom_params)
    return json.loads(tomtom_res.text)['flowSegmentData']


def cal_tomtom_congestion(c_time, f_time):
    x = c_time / f_time
    if x == 1:
        return 1  # 畅通, 绿
    elif 1 < x < 1.3:
        return 2  # 比较拥挤, 黄
    else:
        return 3  # 非常拥堵, 红


def func_u(k):
    return 1 / (0.0161 * math.exp(0.0208 * k))


def func_q(u):
    return 48.08 * u * (math.log(1 / u) + 4.129)


def cal_my_congestion(u):
    if u >= 50:
        return 1
    elif 45 <= u < 50:
        return 2
    else:
        return 3


def process_camera_info(camera_info):
    tomtom_content = tomtom_traffic(camera_info['location']['latitude'], camera_info['location']['longitude'])
    car, truck, bus, motorbike, tricycle = my_count_vehicles(camera_info['image'])
    tomtom_congestion = cal_tomtom_congestion(tomtom_content['currentTravelTime'], tomtom_content['freeFlowTravelTime'])
    u = func_u(car + truck + bus)
    my_congestion = cal_my_congestion(u)
    congestion = math.ceil((tomtom_congestion + my_congestion) / 2)
    return {'camera_id': camera_info['camera_id'],
            'image_url': camera_info['image'],
            'latitude': camera_info['location']['latitude'],
            'longitude': camera_info['location']['longitude'],
            'frc': tomtom_content['frc'],
            'currentSpeed': tomtom_content['currentSpeed'],
            'freeFlowSpeed': tomtom_content['currentSpeed'],
            'currentTravelTime': tomtom_content['currentTravelTime'],
            'freeFlowTravelTime': tomtom_content['freeFlowTravelTime'],
            'confidence': tomtom_content['confidence'],
            'roadClosure': tomtom_content['roadClosure'],
            'car': car,
            'truck': truck,
            'bus': bus,
            'motorbike': motorbike,
            'tricycle': tricycle,
            'tomtom_congestion': tomtom_congestion,
            'my_congestion': my_congestion,
            'congestion': congestion}

#请求data.gov.sg获得摄像头图像信息
data_params = {'date_time': date_time}
data_res = requests.get(url=data_url, params=data_params)

# 获取包含所有相机信息的列表
cameras = json.loads(data_res.text)['items'][0]['cameras']

# 将相机信息转换为RDD
camera_rdd = spark.sparkContext.parallelize(cameras)

# 使用map函数将process_image函数应用于每个URL，获取图片信息
image_info_rdd = camera_rdd.map(process_camera_info)

processed_info_list = image_info_rdd.collect()

# 将相机信息列表转换为DataFrame，并保存为csv文件
df = pd.DataFrame(processed_info_list)
# df.write.mode("overwrite").csv(sys.argv[2])
# df.to_csv("processed_images.csv", index=False)

# 将DataFrame保存为CSV文件
csv_buffer = StringIO()
df.to_csv(csv_buffer, index=False)
csv_string = csv_buffer.getvalue()


# 将CSV文件上传到S3 bucket
s3_bucket = "emr-vision-model"
s3_key = "output/resaults.csv"  # 上传到S3的文件路径和名称

# 创建S3客户端
s3 = boto3.client('s3')

# 上传CSV文件到S3 bucket
# s3_client.upload_file(output_csv_file, s3_bucket, s3_key)

s3.put_object(Bucket=s3_bucket, Key=s3_key, Body=csv_string)

