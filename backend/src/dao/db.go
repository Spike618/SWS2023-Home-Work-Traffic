package dao

import (
	"database/sql"
	"demo/src/config"
	"demo/src/consts"
	"demo/src/output"
	"fmt"
	"log"
)

// Database vars
var db *sql.DB

func InitDb() {
	var err error

	// link
	dbConfig := config.GetYamlConfig().Database
	db, err = sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%s)/%s",
		dbConfig.Username, dbConfig.Password, dbConfig.Url, dbConfig.Port, dbConfig.DbName))
	if err != nil {
		fmt.Println(err)
		output.Print(consts.Dao, "Open database fail!")
	}

	// detect link state
	err = db.Ping()
	if err != nil {
		output.Print(consts.Dao, "Database link fail!")
		log.Fatal(err)
	} else {
		output.Print(consts.Dao, "Database link successfully.")
	}
}

func CloseDb() {
	db.Close()
	output.Print(consts.Dao, "Database close.")
}
