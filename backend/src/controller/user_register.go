package controller

import (
	"demo/src/consts"
	"demo/src/model"
	"demo/src/output"
	"demo/src/service"
	"demo/src/utils"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UserRegisterGet(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}

func UserRegisterPost(c *gin.Context) {
	// get request
	var request model.RegisterLoginRequest
	if err := c.BindJSON(&request); err != nil {
		output.Print(consts.Controller, "Body invalid")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.FAIL,
			"msg":  consts.InvalidRequest,
			"data": nil,
		})
		return
	}

	// get parameters
	email := request.Email
	password := request.Password

	// register
	output.Print(consts.Controller, "Register with email="+email+", password="+password)
	if utils.Check(email, password) == false {
		output.Print(consts.Controller, "Register fail, invalid email or password")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.FAIL,
			"msg":  "Register fail, invalid email or password",
			"data": nil,
		})
	}
	ok := service.Register(email, password)

	// send response
	if ok {
		output.Print(consts.Controller, "Register success")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.SUCCESS,
			"msg":  "Register success",
			"data": nil,
		})
	} else {
		output.Print(consts.Controller, "Register fail, may email exists")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.FAIL,
			"msg":  "Register fail, may email exists",
			"data": nil,
		})
	}
}
