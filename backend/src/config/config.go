package config

import (
	"gopkg.in/yaml.v2"
	"io/ioutil"
)

type Config struct {
	Service struct {
		TrafficImagesUrl string `yaml:"traffic_images_url"`
<<<<<<< HEAD
		TomtomRouteUrl   string `yaml:"tomtom_route_url"`
		TomtomTrafficUrl string `yaml:"tomtom_traffic_url"`
		TomTomKey        string `yaml:"tomtom_key"`
		BaiduUrl         string `yaml:"baidu_url"`
=======
>>>>>>> master
	} `yaml:"service"`
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
