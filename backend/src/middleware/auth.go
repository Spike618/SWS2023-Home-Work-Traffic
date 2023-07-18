package middleware

import (
	"demo/src/consts"
	"demo/src/output"
	"demo/src/utils"
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
)

func AUTHMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("token")

		// for login, go through middleware without authentic
		url := c.Request.URL.String()
		if strings.Contains(url, "/user/login") ||
			strings.Contains(url, "/admin/login") ||
			strings.Contains(url, "/user/register") {
			c.Next()
			return
		}

		// Parse token and authentic
		tokenParse, claims, err := utils.ParseToken(token)
		if err != nil || !tokenParse.Valid {
			output.Print("Middleware", "Authentic fail. token invalid")
			c.JSON(http.StatusUnauthorized, gin.H{
				"code": consts.FAIL,
				"msg":  "Authentic fail. No authority",
				"data": nil,
			})
			c.Abort()
		} else {
			userId := claims.UserId
			auth := claims.Auth

			if strings.Contains(url, "admin") && auth < 1 {
				c.JSON(http.StatusUnauthorized, gin.H{
					"code": consts.FAIL,
					"msg":  "Authentic fail. No Auth to enter admin page",
					"data": nil,
				})
				c.Abort()
			}
			// get userId in claims and judge
			if userId == consts.NotExistId {
				output.Print("Middleware", "Authentic fail. empty ID")
				c.JSON(http.StatusUnauthorized, gin.H{
					"code": consts.SUCCESS,
					"msg":  "Authentic fail. User not exist",
					"data": nil,
				})
				c.Abort()
			} else {
				output.Print("Middleware", "Authentic success. ID = "+string(userId))
				// put userId into c for following process
				c.Set("UserId", userId)
				c.Next()
			}
		}
	}
}
