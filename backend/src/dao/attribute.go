package dao

var AttributeUser = make(map[string]string)

func InitAttribute() {
	AttributeUser["ID"] = "id"
	AttributeUser["Auth"] = "auth"
	AttributeUser["Email"] = "email"
	AttributeUser["Password"] = "password"
	AttributeUser["Name"] = "name"
	AttributeUser["Profile"] = "profile"
	AttributeUser["Point1"] = "point1"
	AttributeUser["Point2"] = "point2"
}
