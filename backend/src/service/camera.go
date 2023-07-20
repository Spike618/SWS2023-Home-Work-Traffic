package service

import (
	"demo/src/consts"
	"demo/src/output"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
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

	output.Print(consts.Service, "road graph for cameras init")
	return nil
}

func GetRoadGraph() []Road {
	return roadGraph
}
