package model

type RegisterLoginRequest struct {
	Email    string `json:"email"`    // email
	Password string `json:"password"` // password
}

type UserIndexRequest struct {
	DestinationLat float64 `json:"destinationLat"`
	DestinationLon float64 `json:"destinationLon"`
	OriginLat      float64 `json:"originLat"`
	OriginLon      float64 `json:"originLon"`
}
