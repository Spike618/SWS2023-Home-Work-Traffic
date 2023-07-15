package main

import (
	"demo/src/consts"
	"demo/src/output"
	"demo/src/router"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"os"
)

var mode string

// main -----------------------------------------------------------------------
func main() {
	if len(os.Args) > 1 {
		mode = os.Args[1]
		if mode == consts.ModeTest {
			fmt.Println("\n#### TEST MODE\n")
			output.Printer(consts.Main, "Init output")
			//dao.Init()
			//defer dao.CloseDb()
			//output.Printer("Main", "Init dao layer")
			router.CreateServer()
			output.Printer("Main", "Init router&controller layer")

		} else if mode == consts.ModeRelease {
			fmt.Println("\n#### RELEASE MODE\n")
			//dao.Init()
			//defer dao.CloseDb()
			//output.Printer("Main", "Init dao layer")
			router.CreateServer()
			output.Printer(consts.Main, "Init router&controller layer")

		} else {
			fmt.Println("Argument invalid, test or release.")
		}
	} else {
		fmt.Println("Should add one argument, test or release.")
	}
}
