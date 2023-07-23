package controller

import (
	"demo/src/consts"
	"demo/src/output"
	"demo/src/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

func Camera(c *gin.Context) {
	// get camera congestion & camera roads congestion
	cameras, _ := service.GetCongestion()

	// process test
	output.Print(consts.Controller, "load all cameras")
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  "get cameras congestion",
		"data": cameras,
	})
}
