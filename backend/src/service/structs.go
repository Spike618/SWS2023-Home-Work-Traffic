package service

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
	FlowSegmentData struct {
		Frc                string  `json:"frc"`
		CurrentSpeed       float64 `json:"currentSpeed"`
		FreeFlowSpeed      float64 `json:"freeFlowSpeed"`
		CurrentTravelTime  float64 `json:"currentTravelTime"`
		FreeFlowTravelTime float64 `json:"freeFlowTravelTime"`
		Confidence         int     `json:"confidence"`
		RoadClosure        bool    `json:"roadClosure"`
		Coordinates        struct {
			Coordinate []struct {
				Latitude  float64 `json:"latitude"`
				Longitude float64 `json:"longitude"`
			} `json:"coordinate"`
		} `json:"coordinates"`
	} `json:"flowSegmentData"`
	Version string `json:"@version"`
}

type Point struct {
	Index      int
	Lat        float64
	Lon        float64
	Congestion int
}
