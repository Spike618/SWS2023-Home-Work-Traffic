package utils

import (
	"github.com/dgrijalva/jwt-go"
	"time"
)

var JwtKey = []byte("SWS3004")

type Claims struct {
	UserId string
	Auth   int
	jwt.StandardClaims
}

func ReleaseToken(userId string, auth int) (string, error) {
	// token expire
	expirationTime := time.Now().Add(7 * 24 * time.Hour)

	claims := &Claims{
		// self design
		UserId: userId,
		Auth:   auth,
		// basic
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
			IssuedAt:  time.Now().Unix(),
			Issuer:    "Spike",
			Subject:   "user token",
		},
	}

	// jwt generate token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(JwtKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func ParseToken(tokenString string) (*jwt.Token, *Claims, error) {
	claims := &Claims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (i interface{}, err error) {
		return JwtKey, nil
	})
	return token, claims, err
}
