package utils

import (
	"fmt"
	"gopkg.in/yaml.v3"
	"os"
)

type Config struct {
	Mysql Mysql `json:"mysql"`
	Redis Redis `json:"redis"`
}

type Mysql struct {
	Url  string
	Port int
}

type Redis struct {
	Host string
	Port int
}

func YamlConfigInit(path string) (Config, bool) {
	config := Config{}

	dataBytes, err := os.ReadFile(path)
	if err != nil {
		fmt.Println("读取文件失败：", err)
		return config, false
	}
	fmt.Println("yaml 文件的内容: \n", string(dataBytes))

	err = yaml.Unmarshal(dataBytes, &config)
	if err != nil {
		fmt.Println("解析 yaml 文件失败：", err)
		return config, false
	}
	fmt.Printf("config → %+v\n", config) // config → {Mysql:{Url:127.0.0.1 Port:3306} Redis:{Host:127.0.0.1 Port:6379}}

	mp := make(map[string]any, 2)
	err = yaml.Unmarshal(dataBytes, mp)
	if err != nil {
		fmt.Println("解析 yaml 文件失败：", err)
		return config, false
	}

	fmt.Printf("map → %+v", config) // config → {Mysql:{Url:127.0.0.1 Port:3306} Redis:{Host:127.0.0.1 Port:6379}}
	return config, true
}
