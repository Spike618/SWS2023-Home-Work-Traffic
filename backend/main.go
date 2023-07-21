package main

import (
	"demo/src/config"
	"demo/src/consts"
	"demo/src/dao"
	"demo/src/output"
	"demo/src/router"
	"demo/src/service"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"os"
	"os/signal"
	"syscall"
)

var mode string

// main -----------------------------------------------------------------------
func main() {
	if len(os.Args) > 1 {
		mode = os.Args[1]
		if mode != consts.ModeTest && mode != consts.ModeRelease {
			fmt.Println("Argument invalid, test or release.")
			return
		}

		fmt.Println("Mode: ", mode)

		output.Print(consts.Main, "Init config")
		wd, err := os.Getwd()
		if err != nil {
			fmt.Println("Error:", err)
			return
		}
		config.Init(wd + "/config/config.yaml")

		output.Print(consts.Main, "Init service layer")
		service.Init()

		output.Print("Main", "Init dao layer")
		dao.Init()

		output.Print(consts.Main, "Gin Start")
		router.CreateServer()

	} else {
		fmt.Println("Should add one argument, test or release.")
	}

	// convert key
	if len(os.Args) > 2 {
		output.Print(consts.Main, fmt.Sprintf("Convert key as: %s", os.Args[2]))
		config.PutInTomTomKey(os.Args[2])
	}

	// exit by os signal
	c := make(chan os.Signal)
	// SIGHUP: terminal closed
	// SIGINT: Ctrl+C
	// SIGTERM: program exit
	// SIGQUIT: Ctrl+/
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	waitElegantExit(c)
}

func waitElegantExit(signalChan chan os.Signal) {
	for sig := range signalChan {
		switch sig {
		case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			// close db
			dao.CloseDb()
			output.Print(consts.Main, "Destroy dao layer")
			output.Print(consts.Main, fmt.Sprintf("Receive exit signal %s, exit!", sig.String()))
			os.Exit(0)
		}
	}
}
