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

func UserLoginGet(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}

func UserLoginPost(c *gin.Context) {
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

	// login
	output.Print(consts.Controller, "Login with email="+email+", password="+password)
	ok, id, auth, point1, point2 := service.Login(email, password)

	// send response
	if ok {
		// release token
		token, _ := utils.ReleaseToken(id, auth)
		output.Print(consts.Controller, "Login success")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.SUCCESS,
			"msg":  "Login success",
			"data": gin.H{
				"token":  token,
				"point1": point1,
				"point2": point2,
			},
		})
	} else {
		output.Print(consts.Controller, "Login fail")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.FAIL,
			"msg":  "Login fail",
			"data": gin.H{
				"token":  nil,
				"point1": nil,
				"point2": nil,
			},
		})
	}
}
