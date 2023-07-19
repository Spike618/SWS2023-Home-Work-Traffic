package config

import (
	"gopkg.in/yaml.v2"
	"io/ioutil"
)

type Config struct {
	Service struct {
		TrafficImagesUrl string `yaml:"traffic_images_url"`
		TomtomRouteUrl   string `yaml:"tomtom_route_url"`
		TomtomTrafficUrl string `yaml:"tomtom_traffic_url"`
		TomTomKey        string `yaml:"tomtom_key"`
	} `yaml:"service"`

	System struct {
		TimeInterval int `yaml:"time_interval"`
	} `yaml:"system"`

	Traffic struct {
		WorkerSize  int     `yaml:"worker_size"`
		CurFreeLow  float64 `yaml:"cur_free_low"`
		CurFreeHigh float64 `yaml:"cur_free_high"`
	} `yaml:"traffic"`

	Database struct {
		Url      string `yaml:"url"`
		Port     string `yaml:"port"`
		DbName   string `yaml:"db_name"`
		Username string `yaml:"username"`
		Password string `yaml:"password"`
	} `yaml:"database"`
}

var config Config

func Init(file string) error {
	yamlFile, err := ioutil.ReadFile(file)
	if err != nil {
		return err
	}

	err = yaml.Unmarshal(yamlFile, &config)
	if err != nil {
		return err
	}

	return nil
}

func GetConfig() Config {
	return config
}
