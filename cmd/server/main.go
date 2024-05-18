package main
 
import (
	"log"
	"net/http"

	"felix/chat-app/pkg/api"
	"felix/chat-app/pkg/config"
	"felix/chat-app/pkg/db"
)

func main(){
	cfg := config.LoadConfig()

	db.Connect(cfg.MongoURI)

	router := api.SetupRouters()
	http.ListenAndServe(":8080",router)
	log.Fatal(http.ListenAndServe(":8080",router))
}