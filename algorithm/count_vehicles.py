from PIL import Image, ImageChops
import cv2
import numpy as np
import requests

def my_count_vehicles(image_url):
    image = Image.open(requests.get(image_url,stream=True).raw)
    image = image.resize((450, 250))
    image_arr = np.array(image)

    grey = cv2.cvtColor(image_arr, cv2.COLOR_BGR2GRAY)
    Image.fromarray(grey)

    blur = cv2.GaussianBlur(grey, (5, 5), 0)
    Image.fromarray(blur)

    dilated = cv2.dilate(blur, np.ones((3, 3)))
    Image.fromarray(dilated)

    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2, 2))
    closing = cv2.morphologyEx(dilated, cv2.MORPH_CLOSE, kernel)
    # Image.fromarray(closing)

    car_cascade_src = 'cars.xml'
    car_cascade = cv2.CascadeClassifier(car_cascade_src)
    cars = car_cascade.detectMultiScale(closing, 1.1, 1)

    cnt = 0
    for (x, y, w, h) in cars:
        cv2.rectangle(image_arr, (x, y), (x + w, y + h), (255, 0, 0), 2)
        cnt += 1

    car, truck, bus, motorbike, tricycle = cnt, 0, 0, 0, 0
    return car, truck, bus, motorbike, tricycle  # 为和百度接口一致, 所以返回这五种车辆的数量
