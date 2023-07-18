package service

import (
	"demo/src/config"
	"demo/src/consts"
)

func CalTomTomCongestion(cTime, fTime float64) int {
	x := cTime / fTime
	if x-config.GetConfig().Traffic.CurFreeLow == 0 {
		return consts.LowCongestion // low, green
	} else if config.GetConfig().Traffic.CurFreeLow < x && x <= config.GetConfig().Traffic.CurFreeHigh {
		return consts.MiddleCongestion // middle, yellow
	} else if x > config.GetConfig().Traffic.CurFreeHigh {
		return consts.HighCongestion // high, red
	} else {
		return consts.FAIL
	}
}
