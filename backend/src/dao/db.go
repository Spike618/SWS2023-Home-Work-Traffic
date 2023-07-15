package dao

import (
	"database/sql"
	"demo/src/output"
	"fmt"
	"log"
)

// Database vars
var db *sql.DB
var AttributeUser = make(map[string]string)
var AttributeCar = make(map[string]string)
var AttributeCharge = make(map[string]string)
var AttributeOrder = make(map[string]string)

func InitDb() {
	var err error

	// link
	db, err = sql.Open("mysql", "???")
	if err != nil {
		fmt.Println(err)
		output.Printer("Dao", "Open database fail!")
	}

	// detect link state
	err = db.Ping()
	if err != nil {
		output.Printer("Dao", "Database link fail!")
		log.Fatal(err)
	} else {
		output.Printer("Dao", "Database link successfully.")
	}
}

func CloseDb() {
	output.Printer("Dao", "Database close.")
	db.Close()
}
