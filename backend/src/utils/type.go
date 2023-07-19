package utils

import "fmt"

func AnyToMapStringString(any interface{}) map[string]string {
	if any == nil {
		return nil
	}
	switch v := any.(type) {
	case map[string]string:
		return v
	case map[string]interface{}:
		m := make(map[string]string)
		for k, v := range v {
			m[k] = fmt.Sprintf("%v", v)
		}
		return m
	default:
		panic(fmt.Sprintf("invalid type: %T", any))
	}
}
