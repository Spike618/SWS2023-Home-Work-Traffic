package service

import (
	"bytes"
	"demo/src/config"
	"demo/src/consts"
	"demo/src/output"
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"time"
)

var roadGraph []Road

func InitRoadGraph() error {
	wd, err := os.Getwd()
	if err != nil {
		fmt.Println("Error:", err)
		return err
	}

	// Read the JSON data from a file
	data, err := ioutil.ReadFile(wd + "//config//graph.json")
	if err != nil {
		fmt.Println("Error reading the file:", err)
		return err
	}

	// Unmarshal the JSON data into the roadSegments variable
	err = json.Unmarshal(data, &roadGraph)
	if err != nil {
		fmt.Println("Errror unmarshalling JSON:", err)
		return err
	}

	output.Print(consts.Service, "read graph.json for camera roads")
	return nil
}

func GetCongestion() ([]Point, [][]Point) {
	/*
		// 创建 AWS 会话
		sess, err := session.NewSession(&aws.Config{
			Region: aws.String("us-east-1"), // 替换为你的 S3 存储桶所在的 AWS 区域
		})
		if err != nil {
			panic(err)
		}

		// 创建 S3 服务客户端
		svc := s3.New(sess)

		// S3 存储桶和对象键
		bucket := "my-bucket-wxy" // 替换为你的 S3 存储桶名称
		key := "result.csv"       // 替换为你的 S3 对象的键

		// 获取 S3 对象
		output, err := svc.GetObject(&s3.GetObjectInput{
			Bucket: aws.String(bucket),
			Key:    aws.String(key),
		})
		if err != nil {
			panic(err)
		}
		defer output.Body.Close()

		data, err := ioutil.ReadAll(output.Body)
		if err != nil {
			panic(err)
		}
		fmt.Println(string(data))
	*/

	// get result.csv
	resp, _ := http.Get("https://my-bucket-wxy.s3.amazonaws.com/result.csv")
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	reader := csv.NewReader(bytes.NewReader(body))
	records, _ := reader.ReadAll()

	output.Print(consts.Service, "get result from s3")

	// get camera congestion from s3
	cameras := make([]Point, 0)
	for i := 1; i < len(records); i++ {
		record := records[i]
		id, _ := strconv.Atoi(record[0])
		lat, _ := strconv.ParseFloat(record[2], 64)
		lon, _ := strconv.ParseFloat(record[3], 64)
		congestion, _ := strconv.Atoi(record[18])
		point := Point{Id: id, Lat: lat, Lon: lon, Congestion: congestion}
		cameras = append(cameras, point)
	}

	// generate roads
	roads := make([][]Point, 0)
	for _, road := range roadGraph {
		// generate each road by points
		points := make([]Point, 0)
		for _, point := range road.Camera {
			points = append(points, Point{Id: point.CameraID, Lat: point.Latitude, Lon: point.Longitude,
				Congestion: cameras[point.CameraID].Congestion})
		}
		roads = append(roads, points)
	}

	return cameras, roads
}

func RequestCameraRecursively() {
	go func() {
		// create ticker
		interval := time.Duration(config.GetYamlConfig().System.TimeInterval) * time.Second
		ticker := time.NewTicker(interval)
		defer ticker.Stop()

		// run circle
		InformEMR()
		for {
			select {
			case <-ticker.C:
				InformEMR()
			}
		}
	}()
}

func InformEMR() {
	url := fmt.Sprintf("%s:%s", config.GetYamlConfig().CameraProcess.Url, config.GetYamlConfig().CameraProcess.Port)
	output.Print(consts.Service, fmt.Sprintf("go routine: %s inform EMR to get camera images", url))
	http.Post(url, "application/json", bytes.NewBuffer([]byte(`"inform"`)))
}
