package service

import (
	"demo/src/config"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math"
	"net/http"
	"net/url"
)

type RouteResponse struct {
	FormatVersion string `json:"formatVersion"`
	Routes        []struct {
		Summary struct {
			LengthInMeters        int    `json:"lengthInMeters"`
			TravelTimeInSeconds   int    `json:"travelTimeInSeconds"`
			TrafficDelayInSeconds int    `json:"trafficDelayInSeconds"`
			TrafficLengthInMeters int    `json:"trafficLengthInMeters"`
			DepartureTime         string `json:"departureTime"`
			ArrivalTime           string `json:"arrivalTime"`
		} `json:"summary"`
		Legs []struct {
			Summary struct {
				LengthInMeters        int    `json:"lengthInMeters"`
				TravelTimeInSeconds   int    `json:"travelTimeInSeconds"`
				TrafficDelayInSeconds int    `json:"trafficDelayInSeconds"`
				TrafficLengthInMeters int    `json:"trafficLengthInMeters"`
				DepartureTime         string `json:"departureTime"`
				ArrivalTime           string `json:"arrivalTime"`
			} `json:"summary"`
			Points []struct {
				Latitude  float64 `json:"latitude"`
				Longitude float64 `json:"longitude"`
			} `json:"points"`
		} `json:"legs"`
		Sections []struct {
			StartPointIndex int    `json:"startPointIndex"`
			EndPointIndex   int    `json:"endPointIndex"`
			SectionType     string `json:"sectionType"`
			TravelMode      string `json:"travelMode"`
		} `json:"sections"`
	} `json:"routes"`
}

type TrafficResponse struct {
}

func SearchPath(originLat float64, originLon float64, destinationLat float64, destinationLon float64) {
	// find paths from API (only have one route)
	routes := GetPath(originLat, originLon, destinationLat, destinationLon, config.GetConfig().Service.TomTomKey)

	// classify routes congestion
	for _, route := range routes.Routes {
		fmt.Println("A route")
		for _, leg := range route.Legs {
			// classify each leg congestion
			fmt.Println(len(leg.Points), leg.Points)
			continue
			for _, point := range leg.Points {
				// classify each point
				fmt.Println(point.Latitude, point.Longitude)
				congestion := CalPath(point.Latitude, point.Longitude)
				fmt.Println(congestion)
			}
		}
	}

}

func GetPath(originLat float64, originLon float64, destinationLat float64, destinationLon float64, key string) RouteResponse {
	var routeResponse RouteResponse

	// build routeURL
	routingURL := config.GetConfig().Service.TomtomRouteUrl +
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

func CalPath(lat float64, lon float64) int {
	congestion := 0

	// api utl
	parameters := url.Values{}
	parameters.Add("point", fmt.Sprintf("%f,%f", lat, lon))
	parameters.Add("unit", "KMPH")
	parameters.Add("openLr", "false")
	parameters.Add("key", config.GetConfig().Service.TomTomKey)
	trafficURL := config.GetConfig().Service.TomtomTrafficUrl + "/json?" + parameters.Encode()

	// request
	response, err := http.Get(trafficURL)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return congestion
	}
	defer response.Body.Close()

	// read body
	data, err := ioutil.ReadAll(response.Body)
	if err != nil {
		fmt.Println("Error reading response:", err)
		return congestion
	}

	// get routes
	var trafficResponse TrafficResponse
	err = json.Unmarshal(data, &trafficResponse)
	if err != nil {
		fmt.Println("Error unmarshaling JSON:", err)
		return congestion
	}

	// calculate congestion

	return congestion
}

func Q(u float64) float64 {
	return 48.08 * u * (math.Log(1/u) + 4.129)
}

func U(k float64) float64 {
	return 1 / (0.0161 * math.Exp(0.0208*k))
}

func calCongestion(u float64) int {
	if u >= 50 {
		return 1
	} else if 45 <= u && u < 50 {
		return 2
	} else {
		return 3
	}
}
