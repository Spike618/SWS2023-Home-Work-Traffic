package service

import (
	"demo/src/config"
	"demo/src/consts"
	"demo/src/output"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

type ImageMetadata struct {
	Height int    `json:"height"`
	Width  int    `json:"width"`
	MD5    string `json:"md5"`
}

type Location struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type Camera struct {
	Timestamp     time.Time     `json:"timestamp"`
	Image         string        `json:"image"`
	Location      Location      `json:"location"`
	CameraID      string        `json:"camera_id"`
	ImageMetadata ImageMetadata `json:"image_metadata"`
}

type Item struct {
	Timestamp time.Time `json:"timestamp"`
	Cameras   []Camera  `json:"cameras"`
}

type APIInfo struct {
	Status string `json:"status"`
}

type PhotoJson struct {
	Items   []Item  `json:"items"`
	APIInfo APIInfo `json:"api_info"`
}

var photoJson PhotoJson

func RequestPhotosRecursively() {
	go func() {
		// create ticker
		interval := time.Duration(config.GetConfig().System.TimeInterval) * time.Second
		ticker := time.NewTicker(interval)
		defer ticker.Stop()

		// run circle
		RequestPhotos()
		for {
			select {
			case <-ticker.C:
				RequestPhotos()
			}
		}
	}()
}

func RequestPhotos() {
	output.Print(consts.Service, "Get photo information")

	// get response
	response, err := http.Get(config.GetConfig().Service.TrafficImagesUrl)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return
	}
	defer response.Body.Close()

	// get response.body
	data, err := ioutil.ReadAll(response.Body)
	if err != nil {
		fmt.Println("Error reading response:", err)
		return
	}

	// parse body into json
	err = json.Unmarshal(data, &photoJson)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	output.Print(consts.Service, "Handle photo successfully")
}
