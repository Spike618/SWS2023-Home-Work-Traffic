import math
import requests
import json
import base64
import urllib
import os
import pandas as pd
from datetime import datetime

os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'

from count_vehicles import my_count_vehicles
from numDetect import detect


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
        # car, truck, bus, motorbike, tricycle = my_count_vehicles(camera['image'])
        car, truck, bus, motorbike, tricycle = detect(camera['image'])

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
    main()
    # meow()
