package config

import (
	// "log"
	"os"
)

type Config struct {
	MongoURI string
}

func LoadConfig() Config {	
	mongoURI := os.Getenv("MONGO_URI")
	if mongoURI == "" {
		mongoURI = "mongodb+srv://felixshi26:1kxdwtg170@cluster0.rwu5vki.mongodb.net/chat_db?retryWrites=true&w=majority"
		// log.Fatal("MONGO_URI environment variable is required!")
	}
	return Config{MongoURI: mongoURI}
}
