package service

import (
	"demo/src/config"
	"demo/src/consts"
)

func CalTomTomCongestion(cTime, fTime float64) int {
	x := cTime / fTime
	trafficConfig := config.GetYamlConfig().Traffic
	if x == trafficConfig.CurFreeLow {
		return consts.LowCongestion // low, green
	} else if trafficConfig.CurFreeLow < x && x <= trafficConfig.CurFreeHigh {
		return consts.MiddleCongestion // middle, yellow
	} else if x > trafficConfig.CurFreeHigh {
		return consts.HighCongestion // high, red
	} else {
		return consts.FAIL
	}
}
