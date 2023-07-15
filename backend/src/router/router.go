package router

import (
	"demo/src/controller"
	"demo/src/middleware"
	"github.com/gin-gonic/gin"
	"net/http"
)

func CreateServer() {
	// create router engine
	gin.SetMode(gin.ReleaseMode)
	router := gin.Default()
	router.Use(middleware.CROSMiddleware(), middleware.AUTHMiddleware())

	// admin
	admin := router.Group("/admin")
	// login page
	admin.GET("/login", controller.AdminLoginGet)
	admin.POST("/login", controller.AdminLoginPost)
	// index page
	admin.GET("/index", controller.AdminIndexGet)
	admin.POST("/index", controller.AdminIndexPost)

	// user
	user := router.Group("/user")
	// login page
	user.GET("/login", controller.UserLoginGet)
	user.POST("/login", controller.UserLoginPost)
	// register page
	user.GET("/register", controller.UserRegisterGet)
	user.POST("/register", controller.UserRegisterPost)
	// index page
	user.GET("/index", controller.UserIndexGet)
	user.POST("/index", controller.UserIndexPost)
	user.PATCH("/index", controller.UserIndexPatch)
	user.DELETE("/index", controller.UserIndexDelete)

	// port
	http.ListenAndServe(":8848", router)
}
