package service

import (
	"demo/src/consts"
	"demo/src/output"
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
)

var roadGraph []Road

func InitRoadGraph() error {
	wd, err := os.Getwd()
	if err != nil {
		fmt.Println("Error:", err)
		return err
	}

	// Read the JSON data from a file
	data, err := ioutil.ReadFile(wd + "\\config\\graph.json")
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

func GetCameraCongestion() [][]Point {
	// get camera congestion csv
	wd, err := os.Getwd()
	if err != nil {
		fmt.Println("Error:", err)
		return [][]Point{}
	}
	opencast, err := os.Open(wd + "\\config\\result.csv")
	if err != nil {
		log.Println("csv文件打开失败！")
		return [][]Point{}
	}
	defer opencast.Close()

	// read content
	ReadCsv := csv.NewReader(opencast)
	ReadAll, err := ReadCsv.ReadAll()
	fmt.Println()

	// get camera congestion from s3
	cameraMap := make(map[int]Point, 0)
	for i := 1; i < len(ReadAll); i++ {
		record := ReadAll[i]
		id, _ := strconv.Atoi(record[0])
		congestion, _ := strconv.Atoi(record[18])
		cameraMap[id] = Point{Id: id, Congestion: congestion}
	}

	// generate roads
	roads := make([][]Point, 0)
	for _, road := range roadGraph {
		// generate each road by points
		points := make([]Point, 0)
		for _, point := range road.Camera {
			points = append(points, Point{Id: point.CameraID, Lat: point.Latitude, Lon: point.Longitude,
				Congestion: cameraMap[point.CameraID].Congestion})
		}
		roads = append(roads, points)
	}

	return roads
}
