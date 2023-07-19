package dao

import (
	"demo/src/consts"
	"demo/src/model"
	"demo/src/output"
	"fmt"
)

func UsersQueryById(id int) (bool, model.User) {
	var user model.User
	user.ID = consts.NotExistId
	user.Auth = consts.InvalidAuth

	// query in users
	sql := fmt.Sprintf("select * from users where %s=?", AttributeUser["ID"])
	output.Print("Dao", fmt.Sprintf("%s, %d", sql, id))

	// prepare
	stmt, err := db.Prepare(sql)
	if err != nil {
		output.Print("Dao", err.Error())
	}
	defer stmt.Close()

	// query after prepare
	rows, err := stmt.Query(id)
	if err != nil {
		output.Print("Dao", err.Error())
		return false, user
	}

	// get result (only return 1st one)
	if rows.Next() {
		err = rows.Scan(&user.ID, &user.Auth, &user.Email, &user.Password, &user.Name, &user.Profile, &user.Point1, &user.Point2)
		if err != nil {
			output.Print("Dao", err.Error())
		}
		return true, user
	}
	return false, user
}

func UsersQueryByEP(email string, password string) (bool, model.User) {
	var user model.User
	user.ID = consts.NotExistId
	user.Auth = consts.InvalidAuth

	// query in users
	sql := fmt.Sprintf("select * from users where %s=? and %s=?", AttributeUser["Email"], AttributeUser["Password"])
	output.Print("Dao", fmt.Sprintf("%s, %s, %s", sql, email, password))

	// prepare
	stmt, err := db.Prepare(sql)
	if err != nil {
		output.Print("Dao", err.Error())
	}
	defer stmt.Close()

	// query after prepare
	rows, err := stmt.Query(email, password)
	if err != nil {
		output.Print("Dao", err.Error())
		return false, user
	}

	// get result (only return 1st one)
	if rows.Next() {
		err = rows.Scan(&user.ID, &user.Auth, &user.Email, &user.Password, &user.Name, &user.Profile, &user.Point1, &user.Point2)
		if err != nil {
			output.Print("Dao", err.Error())
		}
		return true, user
	}
	return false, user
}

func UsersQueryByEmail(email string) (bool, model.User) {
	var user model.User
	user.ID = consts.NotExistId
	user.Auth = consts.InvalidAuth

	// query in users
	sql := fmt.Sprintf("select * from users where %s=?", AttributeUser["Email"])
	output.Print("Dao", fmt.Sprintf("%s, %s", sql, email))

	// prepare
	stmt, err := db.Prepare(sql)
	if err != nil {
		output.Print("Dao", err.Error())
	}
	defer stmt.Close()

	// query after prepare
	rows, err := stmt.Query(email)
	if err != nil {
		output.Print("Dao", err.Error())
		return false, user
	}

	// get result (only return 1st one)
	if rows.Next() {
		err = rows.Scan(&user.ID, &user.Auth, &user.Email, &user.Password, &user.Name, &user.Profile, &user.Point1, &user.Point2)
		if err != nil {
			output.Print("Dao", err.Error())
		}
		return true, user
	}
	return false, user
}

func UsersInsert(email string, password string) bool {
	// query for exist
	exist, _ := UsersQueryByEmail(email)
	if exist == true {
		output.Print("Dao", fmt.Sprintf("%s already exists", email))
		return false
	}

	// insert in users
	sql := "insert into users (" +
		AttributeUser["Auth"] + ", " +
		AttributeUser["Email"] + ", " +
		AttributeUser["Password"] + ", " +
		AttributeUser["Name"] + ", " +
		AttributeUser["Profile"] + ", " +
		AttributeUser["Point1"] + ", " +
		AttributeUser["Point2"] +
		fmt.Sprintf(") values (%d, ?, ?, '%s', '', '', '')", consts.DefaultAuth, consts.DefaultName)
	output.Print("Dao", fmt.Sprintf("%s, %s, %s", sql, email, password))

	// prepare
	stmt, err := db.Prepare(sql)
	if err != nil {
		output.Print("Dao", err.Error())
	}
	defer stmt.Close()

	// exec after prepare
	if _, err = stmt.Exec(email, password); err != nil {
		output.Print("Dao", err.Error())
		return false
	}
	return true
}
