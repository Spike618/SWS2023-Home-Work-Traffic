package dao

import (
	"database/sql"
	"demo/src/config"
	"demo/src/output"
	"fmt"
	"log"
)

// Database vars
var db *sql.DB

func InitDb() {
	var err error

	// link
	db, err = sql.Open("mysql", config.GetConfig().Database.Username+
		":"+config.GetConfig().Database.Password+
		fmt.Sprintf("@tcp(%s:%s)", config.GetConfig().Database.Url, config.GetConfig().Database.Port)+
		"/"+config.GetConfig().Database.DbName)
	if err != nil {
		fmt.Println(err)
		output.Print("Dao", "Open database fail!")
	}

	// detect link state
	err = db.Ping()
	if err != nil {
		output.Print("Dao", "Database link fail!")
		log.Fatal(err)
	} else {
		output.Print("Dao", "Database link successfully.")
	}
}

func CloseDb() {
	db.Close()
	output.Print("Dao", "Database close.")
}
