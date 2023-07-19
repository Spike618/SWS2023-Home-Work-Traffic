package controller

import (
	"demo/src/consts"
	"github.com/gin-gonic/gin"
	"net/http"
)

func AdminIndexGet(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}

func AdminIndexPost(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}
