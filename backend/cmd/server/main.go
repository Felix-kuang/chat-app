package main

import (
	"log"
	"net/http"

	"felix/chat-app/pkg/api"
	"felix/chat-app/pkg/config"
	"felix/chat-app/pkg/db"
)

func main() {
	cfg := config.LoadConfig()

	db.Connect(cfg.MongoURI)

	router := api.SetupRouters()
	log.Fatal(http.ListenAndServe(":8080", corsMiddleware(router)))
}

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET,POST,OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}
