package service

import (
	"demo/src/config"
	"demo/src/consts"
	"demo/src/dao"
	"demo/src/output"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math"
	"net/http"
	"net/url"
	"sync"
)

func SearchPath(id int, originLat, originLon, destinationLat, destinationLon float64) [][][]Point {
	go func() {
		dao.UsersUpdatePoints(id, fmt.Sprintf("%.6f,%.6f", originLat, originLon),
			fmt.Sprintf("%.6f,%.6f", destinationLat, destinationLon))
	}()

	// find paths from API (only have one route)
	routes := GetRoutes(originLat, originLon, destinationLat, destinationLon, config.GetYamlConfig().Service.TomTomKey)
	output.Print(consts.Service, "Find routes successfully")

	// routes congestion
	routesCongestion := make([][][]Point, 0)
	for _, route := range routes.Routes {
		// route congestion
		routeCongestion := make([][]Point, 0)

		// calculate leg congestion
		for _, leg := range route.Legs {
			size := len(leg.Points)

			// leg maybe too long, so sqrt is necessary
			interval := 1
			if config.GetYamlConfig().Traffic.PointThreshold < size && size <= 2*config.GetYamlConfig().Traffic.PointThreshold {
				interval = 2
			} else if 2*config.GetYamlConfig().Traffic.PointThreshold < size && size <= 4*config.GetYamlConfig().Traffic.PointThreshold {
				interval = 4
			} else if 4*config.GetYamlConfig().Traffic.PointThreshold < size {
				interval = int(math.Sqrt(float64(size)))
			}
			indexs := make([]int, 0)
			for index := 0; index < size; index += interval {
				indexs = append(indexs, index)
			}
			if (size-1)%interval != 0 {
				indexs = append(indexs, size-1)
			}
			fmt.Println(interval, indexs)

			// leg congestion
			legCongestion := make([]Point, len(indexs))

			// define job & result
			numJobs := len(leg.Points)
			jobs := make(chan Point, numJobs)
			results := make(chan Point, numJobs)

			// start workers
			numWorkers := config.GetYamlConfig().Traffic.WorkerSize
			var wg sync.WaitGroup
			for i := 0; i < numWorkers; i++ {
				wg.Add(1)
				go Worker(jobs, results, &wg)
			}

			// classify each point congestion of this leg -----------------------------------------
			// send all jobs
			for i, index := range indexs {
				point := leg.Points[index]
				jobs <- Point{
					Id:  i,
					Lat: point.Latitude,
					Lon: point.Longitude,
				}
			}
			close(jobs)

			// collect all results
			wg.Wait()
			close(results)

			// generate congestion of this leg
			for result := range results {
				legCongestion[result.Id] = result
			}
			// add leg into route
			routeCongestion = append(routeCongestion, legCongestion)
		}
		// add route into routes
		routesCongestion = append(routesCongestion, routeCongestion)
	}

	output.Print(consts.Service, "Generate routes with point-congestion successfully")
	fmt.Println(routesCongestion)
	return routesCongestion
}

func GetRoutes(originLat, originLon, destinationLat, destinationLon float64, key string) RouteResponse {
	var routeResponse RouteResponse

	// build routeURL
	routingURL := config.GetYamlConfig().Service.TomtomRouteUrl +
		fmt.Sprintf("%.6f,%.6f:%.6f,%.6f", originLat, originLon, destinationLat, destinationLon) +
		"/json?" + fmt.Sprintf("key=%s", key)
	response, err := http.Get(routingURL)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return routeResponse
	}
	defer response.Body.Close()

	// read body
	data, err := ioutil.ReadAll(response.Body)
	if err != nil {
		fmt.Println("Error reading response:", err)
		return routeResponse
	}

	// get routes
	err = json.Unmarshal(data, &routeResponse)
	if err != nil {
		fmt.Println("Error unmarshaling JSON:", err)
		return routeResponse
	}
	return routeResponse
}

func Worker(jobs <-chan Point, results chan<- Point, wg *sync.WaitGroup) {
	for j := range jobs {
		congestion := CalPointCongestion(j.Lat, j.Lon)

		var result Point
		result.Id = j.Id
		result.Lat = j.Lat
		result.Lon = j.Lon
		result.Congestion = congestion
		results <- result
	}
	wg.Done()
}

func CalPointCongestion(lat, lon float64) int {
	congestion := 0

	// api utl
	parameters := url.Values{}
	parameters.Add("point", fmt.Sprintf("%f,%f", lat, lon))
	parameters.Add("unit", "KMPH")
	parameters.Add("openLr", "false")
	parameters.Add("key", config.GetYamlConfig().Service.TomTomKey)
	trafficURL := config.GetYamlConfig().Service.TomtomTrafficUrl + "/json?" + parameters.Encode()

	// send request
	response, err := http.Get(trafficURL)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return congestion
	}
	defer response.Body.Close()

	// get body
	data, err := ioutil.ReadAll(response.Body)
	if err != nil {
		fmt.Println("Error reading response:", err)
		return congestion
	}

	// parse point traffic
	var trafficResponse TrafficResponse
	err = json.Unmarshal(data, &trafficResponse)
	if err != nil {
		fmt.Println("Error unmarshaling JSON:", err)
		return congestion
	}

	// calculate congestion
	return CalTomTomCongestion(trafficResponse.FlowSegmentData.CurrentTravelTime,
		trafficResponse.FlowSegmentData.FreeFlowTravelTime)
}
