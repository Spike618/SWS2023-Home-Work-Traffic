package controller

import (
	"demo/src/consts"
	"demo/src/model"
	"demo/src/output"
	"demo/src/service"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UserIndexGet(c *gin.Context) {
	// get camera congestion

	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}

func UserIndexPost(c *gin.Context) {
	// get request
	var request model.UserIndexRequest
	if err := c.BindJSON(&request); err != nil {
		output.Print(consts.Controller, "Body invalid")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.FAIL,
			"msg":  consts.InvalidRequest,
			"data": nil,
		})
		return
	}

	// process path with congestion
	routes := service.SearchPath(request.OriginLat, request.OriginLon, request.DestinationLat, request.DestinationLon)

	// send response
	output.Print(consts.Controller, fmt.Sprintf("Find routes for (%.6f,%.6f:%.6f,%.6f)",
		request.OriginLat, request.OriginLon, request.DestinationLat, request.DestinationLon))
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  "Find routes success",
		"data": routes,
	})
}

func UserIndexPatch(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}

func UserIndexDelete(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}
