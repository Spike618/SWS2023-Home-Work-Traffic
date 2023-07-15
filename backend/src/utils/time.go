package utils

import (
	"fmt"
	"time"
)

func TimeDuration(start string, finish string) float32 {
	format_start, err := time.Parse("2006-01-02 15:04:05", start)
	if err != nil {
		fmt.Println(err)
	}
	format_finish, err := time.Parse("2006-01-02 15:04:05", finish)
	if err != nil {
		fmt.Println(err)
	}
	return float32(format_finish.Unix()-format_start.Unix()) / 3600
}
