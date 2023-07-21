package service

import (
	"demo/src/consts"
	"demo/src/dao"
	"demo/src/output"
)

func Register(email string, password string) bool {
	ok := dao.UsersInsert(email, password)
	if !ok {
		output.Print(consts.Service, "User register fail")
		return false
	}
	output.Print(consts.Service, "User register success")
	return true
}

func Login(email string, password string) (bool, int, int, string, string) {
	ok, user := dao.UsersQueryByEP(email, password)
	if !ok {
		output.Print(consts.Service, "User not exist")
		return false, consts.NotExistId, consts.InvalidAuth, consts.EmptyStr, consts.EmptyStr
	}
	output.Print(consts.Service, "User exist")
	return true, user.ID, user.Auth, user.Point1, user.Point2
}
