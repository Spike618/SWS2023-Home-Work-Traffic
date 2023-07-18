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

	//创建csv读取接口实例
	ReadCsv := csv.NewReader(opencast)

	//获取一行内容，一般为第一行内容
	read, _ := ReadCsv.Read() //返回切片类型：[chen  hai wei]
	fmt.Println(read)

	//读取所有内容
	ReadAll, err := ReadCsv.ReadAll() //返回切片类型：[[s s ds] [a a a]]
	fmt.Println(ReadAll)

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
	print(slice)
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  "test",
		"data": slice,
	})
}
