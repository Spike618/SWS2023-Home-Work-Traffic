package controller

import (
	"demo/src/consts"
	"demo/src/model"
	"demo/src/output"
	"demo/src/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UserIndexGet(c *gin.Context) {

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

	// generate path
	service.SearchPath(request.OriginLat, request.OriginLon, request.DestinationLat, request.DestinationLon)
	// send response

}

func UserIndexPatch(c *gin.Context) {

}

func UserIndexDelete(c *gin.Context) {

}
