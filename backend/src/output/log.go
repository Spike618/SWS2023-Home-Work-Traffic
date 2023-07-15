package output

import (
	"demo/src/consts"
	"fmt"
	"os"
	"strings"
	"time"
)

const file_perm = 0o644
const log_path = "./log/"

var log_file *os.File

// init
func Log_init() {
	// get log_file name
	cur := strings.Split(time.Now().Format("2006-01-02 15:04:05"), " ")
	date := cur[0]
	time := strings.Replace(cur[1], ":", "-", -1)
	log_file_name := date + "_" + time + ".log"

	var err error
	log_file, err = os.OpenFile(log_path+log_file_name, os.O_CREATE|os.O_APPEND, file_perm)
	if err != nil {
		fmt.Println("Open " + log_file_name + " fail!")
		//os.Exit(1)
	}
}

// insert an info
func Log_insert(info string) {
	if os.Args[1] == consts.ModeRelease {
	}
	log_file.WriteString(info + "\n")
	log_file.Sync()
}

// close
func Log_close() {
	log_file.Close()
}
