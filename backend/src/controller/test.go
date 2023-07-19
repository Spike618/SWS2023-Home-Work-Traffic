package controller

import (
	"demo/src/consts"
	"demo/src/output"
	"encoding/csv"
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"os"
	"strconv"
)

func Test(c *gin.Context) {
	wd, err := os.Getwd()
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	opencast, err := os.Open(wd + "\\config\\result.csv")
	if err != nil {
		log.Println("csv文件打开失败！")
	}
	defer opencast.Close()

	// read content
	ReadCsv := csv.NewReader(opencast)
	ReadAll, err := ReadCsv.ReadAll() //返回切片类型：[[s s ds] [a a a]]

	type Triplet struct {
		Id  int
		Lat float64
		Lon float64
	}
	slice := make([]Triplet, 0)
	for _, record := range ReadAll {
		id, _ := strconv.Atoi(record[0])
		lat, _ := strconv.ParseFloat(record[2], 64)
		lon, _ := strconv.ParseFloat(record[3], 64)
		triplet := Triplet{Id: id, Lat: lat, Lon: lon}
		slice = append(slice, triplet)
	}

	// process user login
	output.Print(consts.Controller, "test")
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  "test",
		"data": slice,
	})
}
