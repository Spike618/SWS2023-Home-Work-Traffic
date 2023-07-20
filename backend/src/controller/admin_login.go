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

func AdminLoginGet(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"code": consts.SUCCESS,
		"msg":  nil,
		"data": nil,
	})
}

func AdminLoginPost(c *gin.Context) {
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
	ok, id, auth, _, _ := service.Login(email, password)

	// send response
	if ok {
		// no auth
		if auth < consts.AdminAuth {
			output.Print(consts.Controller, "Login no auth")
			c.JSON(http.StatusOK, gin.H{
				"code": consts.FAIL,
				"msg":  "Login no auth",
				"data": gin.H{
					"token": nil,
				},
			})
		}

		// release token
		token, _ := utils.ReleaseToken(id, auth)
		output.Print(consts.Controller, "Login success")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.SUCCESS,
			"msg":  "Login success",
			"data": gin.H{
				"token": token,
			},
		})
	} else {
		output.Print(consts.Controller, "Login fail")
		c.JSON(http.StatusOK, gin.H{
			"code": consts.FAIL,
			"msg":  "Login fail",
			"data": gin.H{
				"token": nil,
			},
		})
	}
}
