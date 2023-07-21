package controller

import (
	"demo/src/consts"
	"demo/src/output"
	"demo/src/service"
	"encoding/csv"
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"os"
	"strconv"
)

func Camera(c *gin.Context) {
	wd, err := os.Getwd()
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	opencast, err := os.Open(wd + "//config//result.csv")
	if err != nil {
		log.Println("csv文件打开失败！")
	}
	defer opencast.Close()

	// read content
	ReadCsv := csv.NewReader(opencast)
	ReadAll, err := ReadCsv.ReadAll()

	// get camera locations
	slice := make([]service.Point, 0)
	for i := 1; i < len(ReadAll); i++ {
		record := ReadAll[i]
		id, _ := strconv.Atoi(record[0])
		lat, _ := strconv.ParseFloat(record[2], 64)
		lon, _ := strconv.ParseFloat(record[3], 64)
		congestion, _ := strconv.Atoi(record[18])
		point := service.Point{Id: id, Lat: lat, Lon: lon, Congestion: congestion}
		slice = append(slice, point)
	}

	// process test
	output.Print(consts.Controller, "load all cameras")
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  "test",
		"data": slice,
	})
}
