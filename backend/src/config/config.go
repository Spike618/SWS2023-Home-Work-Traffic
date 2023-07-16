package config

import (
	"gopkg.in/yaml.v2"
	"io/ioutil"
)

type Config struct {
	Service struct {
		TrafficImagesUrl string `yaml:"traffic_images_url"`
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
