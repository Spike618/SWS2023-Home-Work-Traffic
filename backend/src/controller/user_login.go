package controller

import (
	"demo/src/consts"
	"demo/src/model"
	"demo/src/output"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UserLoginGet(c *gin.Context) {

}

func UserLoginPost(c *gin.Context) {
	// get request
<<<<<<< HEAD
	var request model.RegisterLoginRequest
=======
	var request model.RegisterLogin
>>>>>>> master
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

	// process user login
	output.Print(consts.Controller, email+" "+password)
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  email + " login success",
		"data": nil,
	})
}
