package model

type User struct {
	ID       int    `db:"id"`
	Auth     int    `db:"auth"`
	Email    string `db:"email"`
	Password string `db:"password"`
	Name     string `db:"name"`
	Profile  string `db:"profile"`
	Point1   string `db:"point1"`
	Point2   string `db:"point2"`
}
