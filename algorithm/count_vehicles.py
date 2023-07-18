# YOLOv5 🚀 by Ultralytics, AGPL-3.0 license
import os
import platform
import sys
from pathlib import Path

import torch

FILE = Path(__file__).resolve()
ROOT = FILE.parents[0]  # YOLOv5 root directory
if str(ROOT) not in sys.path:
    sys.path.append(str(ROOT))  # add ROOT to PATH
ROOT = Path(os.path.relpath(ROOT, Path.cwd()))  # relative

from models.common import DetectMultiBackend
from utils.dataloaders import IMG_FORMATS, VID_FORMATS, LoadImages, LoadScreenshots, LoadStreams
from utils.general import (LOGGER, Profile, check_file, check_img_size, check_imshow, check_requirements, colorstr, cv2,
                           increment_path, non_max_suppression, print_args, scale_boxes, strip_optimizer, xyxy2xywh)
from utils.plots import Annotator, colors, save_one_box
from utils.torch_utils import select_device, smart_inference_mode
# def my_count_vehicles(image_url):
#     image = Image.open(requests.get(image_url,stream=True).raw)
#     image = image.resize((450, 250))
#     image_arr = np.array(image)

#     grey = cv2.cvtColor(image_arr, cv2.COLOR_BGR2GRAY)
#     Image.fromarray(grey)

#     blur = cv2.GaussianBlur(grey, (5, 5), 0)
#     Image.fromarray(blur)

#     dilated = cv2.dilate(blur, np.ones((3, 3)))
#     Image.fromarray(dilated)

#     kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2, 2))
#     closing = cv2.morphologyEx(dilated, cv2.MORPH_CLOSE, kernel)
#     # Image.fromarray(closing)

#     car_cascade_src = 'cars.xml'
#     car_cascade = cv2.CascadeClassifier(car_cascade_src)
#     cars = car_cascade.detectMultiScale(closing, 1.1, 1)

#     cnt = 0
#     for (x, y, w, h) in cars:
#         cv2.rectangle(image_arr, (x, y), (x + w, y + h), (255, 0, 0), 2)
#         cnt += 1

#     car, truck, bus, motorbike, tricycle = cnt, 0, 0, 0, 0
#     return car, truck, bus, motorbike, tricycle  # 为和百度接口一致, 所以返回这五种车辆的数量

# source是将要识别文件的url
def my_count_vehicles(source):
    weights=ROOT / 'train_result/weights/best.pt'  # model path or triton URL
    data=ROOT / 'data/coco128.yaml'  # dataset.yaml path
    imgsz=(640, 640)  # inference size (height, width)
    conf_thres=0.25  # confidence threshold
    iou_thres=0.45  # NMS IOU threshold
    max_det=1000  # maximum detections per image
    device=''  # cuda device, i.e. 0 or 0,1,2,3 or cpu
    save_txt=False  # save results to *.txt
    save_crop=False  # save cropped prediction boxes
    nosave=False  # do not save images/videos
    classes=None  # filter by class: --class 0, or --class 0 2 3
    agnostic_nms=False  # class-agnostic NMS
    augment=False  # augmented inference
    visualize=False  # visualize features
    project=ROOT / 'runs/detect'  # save results to project/name
    name='exp'  # save results to project/name
    exist_ok=False  # existing project/name ok, do not increment
    line_thickness=3  # bounding box thickness (pixels)
    half=False  # use FP16 half-precision inference
    dnn=False  # use OpenCV DNN for ONNX inference
    vid_stride=1  # video frame-rate stride
    car, truck, bus, motor, tricycle = 0, 0, 0, 0, 0
    source = str(source)
    # save_img = not nosave and not source.endswith('.txt')  # save inference images
    save_img = False # don't save photos
    is_file = Path(source).suffix[1:] in (IMG_FORMATS + VID_FORMATS)
    is_url = source.lower().startswith(('rtsp://', 'rtmp://', 'http://', 'https://'))
    webcam = source.isnumeric() or source.endswith('.streams') or (is_url and not is_file)
    screenshot = source.lower().startswith('screen')
    if is_url and is_file:
        source = check_file(source)  # download


    # Load model
    device = select_device(device)
    model = DetectMultiBackend(weights, device=device, dnn=dnn, data=data, fp16=half)
    stride, names, pt = model.stride, model.names, model.pt
    imgsz = check_img_size(imgsz, s=stride)  # check image size

    # Dataloader
    bs = 1  # batch_size
    if webcam:
        view_img = check_imshow(warn=True)
        dataset = LoadStreams(source, img_size=imgsz, stride=stride, auto=pt, vid_stride=vid_stride)
        bs = len(dataset)
    elif screenshot:
        dataset = LoadScreenshots(source, img_size=imgsz, stride=stride, auto=pt)
    else:
        dataset = LoadImages(source, img_size=imgsz, stride=stride, auto=pt, vid_stride=vid_stride)
    vid_path, vid_writer = [None] * bs, [None] * bs

    # Run inference
    model.warmup(imgsz=(1 if pt or model.triton else bs, 3, *imgsz))  # warmup
    seen, windows, dt = 0, [], (Profile(), Profile(), Profile())
    for path, im, im0s, vid_cap, s in dataset:
        with dt[0]:
            im = torch.from_numpy(im).to(model.device)
            im = im.half() if model.fp16 else im.float()  # uint8 to fp16/32
            im /= 255  # 0 - 255 to 0.0 - 1.0
            if len(im.shape) == 3:
                im = im[None]  # expand for batch dim

        # Inference
        with dt[1]:
            visualize = increment_path(save_dir / Path(path).stem, mkdir=True) if visualize else False
            pred = model(im, augment=augment, visualize=visualize)

        # NMS
        with dt[2]:
            pred = non_max_suppression(pred, conf_thres, iou_thres, classes, agnostic_nms, max_det=max_det)

        # Second-stage classifier (optional)
        # pred = utils.general.apply_classifier(pred, classifier_model, im, im0s)

        # Process predictions
        for i, det in enumerate(pred):  # per image
            seen += 1
            if webcam:  # batch_size >= 1
                p, im0, frame = path[i], im0s[i].copy(), dataset.count
                s += f'{i}: '
            else:
                p, im0, frame = path, im0s.copy(), getattr(dataset, 'frame', 0)

            p = Path(p)  # to Path
            s += '%gx%g ' % im.shape[2:]  # print string
            gn = torch.tensor(im0.shape)[[1, 0, 1, 0]]  # normalization gain whwh
            imc = im0.copy() if save_crop else im0  # for save_crop
            annotator = Annotator(im0, line_width=line_thickness, example=str(names))
            if len(det):
                # Rescale boxes from img_size to im0 size
                det[:, :4] = scale_boxes(im.shape[2:], det[:, :4], im0.shape).round()

                # Print results
                for c in det[:, 5].unique():
                    n = (det[:, 5] == c).sum()  # detections per class
                    s += f"{n} {names[int(c)]}{'s' * (n > 1)}, "  # add to string
                
                for c in det[:, 5].unique():
                    n = (det[:, 5] == c).sum().item()  # detections per class
                    if names[int(c)]=='car':
                        car = n
                    if names[int(c)]=='motor':
                        motor = n
                    if names[int(c)]=='bus':
                        bus = n
                    if names[(int(c))]=='tricycle':
                        tricycle = n
                    if names[int(c)]=='truck':
                        truck = n
            os.remove(source)
            return car, truck, bus, motor, tricycle

