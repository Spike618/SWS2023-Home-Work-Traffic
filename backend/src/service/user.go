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

func Login(email string, password string) (bool, int, int) {
	ok, user := dao.UsersQueryByEP(email, password)
	if !ok {
		output.Print(consts.Service, "User not exist")
		return false, consts.NotExistId, consts.InvalidAuth
	}
	output.Print(consts.Service, "User exist")
	return true, user.ID, user.Auth
}
