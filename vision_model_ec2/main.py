import math
import boto3
import requests
import json
import base64
import urllib
import os
import pandas as pd
from datetime import datetime

from count_vehicles import my_count_vehicles

from flask import Flask, request
app = Flask(__name__)

@app.route('/', methods=['POST'])
def receive_post():
    data = request.get_data() # 获取请求中的原始数据，可以是任意格式
    main()
    return 'OK' # 返回一个响应

os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'

date_time = datetime.now().strftime('%Y-%m-%dT%H:%M:%S')
data_url = 'https://api.data.gov.sg/v1/transport/traffic-images/'
tomtom_url = 'https://api.tomtom.com/traffic/services/4/flowSegmentData/relative0/10/json/'
baidu_url = "https://aip.baidubce.com/rest/2.0/image-classify/v1/vehicle_detect?" \
            "access_token=24.0fc731ae4c8138e6eefcaf3eb274ea01.2592000.1691808843.282335-36100278"  # expire in 30 days


def tomtom_traffic(latitude, longitude):
    tomtom_params = {'point': '%s,%s' % (latitude, longitude),
                     'unit': 'KMPH',
                     'openLr': 'false',
                     'key': 'ze8YSxPAewmBAh4GbX0coKQz6Yuib3Bz'}
    tomtom_res = requests.get(url=tomtom_url, params=tomtom_params)
    return json.loads(tomtom_res.text)['flowSegmentData']


def baidu_count_vehicles(image_url):
    res = requests.get(url=image_url)
    image_64 = base64.b64encode(res.content).decode("utf8")
    image_64 = urllib.parse.quote_plus(image_64)
    baidu_headers = {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json'}
    baidu_data = 'image=%s' % image_64
    baidu_res = requests.request("POST", url=baidu_url, headers=baidu_headers, data=baidu_data)
    baidu_content = json.loads(baidu_res.text)['vehicle_num']
    return baidu_content['car'], baidu_content['truck'], baidu_content['bus'], baidu_content['motorbike'], baidu_content['tricycle']


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


def main():
    data_params = {'date_time': date_time}
    data_res = requests.get(url=data_url, params=data_params)
    cameras = json.loads(data_res.text)['items'][0]['cameras']

    data = []
    i = 0
    for camera in cameras:
        i += 1
        print(i)

        tomtom_content = tomtom_traffic(camera['location']['latitude'], camera['location']['longitude'])
        # car, truck, bus, motorbike, tricycle = baidu_count_vehicles(camera['image'])
        car, truck, bus, motorbike, tricycle = my_count_vehicles(camera['image'])

        tomtom_congestion = cal_tomtom_congestion(tomtom_content['currentTravelTime'], tomtom_content['freeFlowTravelTime'])
        u = func_u(car + truck + bus)
        my_congestion = cal_my_congestion(u)
        congestion = math.ceil((tomtom_congestion + my_congestion) / 2)

        data.append({'camera_id': camera['camera_id'],
                     'image_url': camera['image'],
                     'latitude': camera['location']['latitude'],
                     'longitude': camera['location']['longitude'],
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
                     'congestion': congestion})
    df = pd.DataFrame(data)
    df.to_csv("result.csv", index=False)


    session = boto3.Session(
    aws_access_key_id='ASIAULQIPMQXJNFQWC4B',
    aws_secret_access_key='kntGV+HKribEZrqeaA/+VwpTiS7fNFaVBmO3XA/4',
    aws_session_token='FwoGZXIvYXdzEDwaDKiUOFeNsenqWaautyLDAa63tKX1dkt1UOiVJKKupaKqkNtw+3Y9Y9Oq6AH/SL27TdDsKT3Jpi/9QcBSHwk6UyluK8o5yC8V6hPhm1um9NcyGa9erovtdkIPyRoMIiFttbSMNpeENK+PrWPC3vIMVq5omeFFW3qa2vEAzkdPe4sUSweW7fNPdTxl6SB92HGaHWLxx5ZqVUlbCLK4fEeX0R5fJpjcJeLzpIhzBmDZkOJy0MSVlSsjMWsMqqGt2hs8IpFI/PqfPR6ILZpZJZfjqerDfij42OelBjItnucafIvO6mHgMOfFRNkGNQSI106xF/qqVZuSNTLUutPLo4wyk9X5Ts8Z3+Pm'
    )
    s3 = session.resource('s3')
    # Filename - File to upload
    # Bucket - Bucket to upload to (the top level directory under AWS S3)
    # Key - S3 object name (can contain subdirectories). If not specified then file_name is used
    s3.meta.client.upload_file(Filename='result.csv', Bucket='dhaiuhwoiwnxiwue', Key='result.csv')




def meow():
    data = pd.read_csv('result.csv')
    for index, row in data.iterrows():
        data.at[index, 'u'] = func_u(row['car'] + row['truck'] + row['bus'])
        data.at[index, 'q'] = func_q(data.at[index, 'u'])
        data.at[index, 'tomtom_congestion'] = cal_tomtom_congestion(row['currentTravelTime'], row['freeFlowTravelTime'])
        data.at[index, 'my_congestion'] = cal_my_congestion(data.at[index, 'u'])
        data.at[index, 'congestion'] = math.ceil((data.at[index, 'tomtom_congestion'] + data.at[index, 'my_congestion']) / 2)
    df = pd.DataFrame(data)
    df.to_csv("meow.csv", index=False)


if __name__ == '__main__':
    app.run()
    # meow()
