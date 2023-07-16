package main

import (
	"demo/src/config"
	"demo/src/consts"
	"demo/src/output"
	"demo/src/router"
	"demo/src/service"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"os"
)

var mode string

// main -----------------------------------------------------------------------
func main() {
	if len(os.Args) > 1 {
		mode = os.Args[1]
		if mode != consts.ModeTest && mode != consts.ModeRelease {
			fmt.Println("Argument invalid, test or release.")
		}

		fmt.Println("Mode: ", mode)

		wd, err := os.Getwd()
		if err != nil {
			fmt.Println("Error:", err)
			return
		}
		config.Init(wd + "\\configs\\config.yaml")
		output.Print(consts.Main, "Init config")

		service.Init()
		output.Print(consts.Main, "Init service")

		//dao.Init()
		//defer dao.CloseDb()
		//output.Print("Main", "Init dao layer")

		output.Print(consts.Main, "Gin Start")
		router.CreateServer()

	} else {
		fmt.Println("Should add one argument, test or release.")
	}
}
