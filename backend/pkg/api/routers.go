package api

import (
	"github.com/gorilla/mux"
)

func SetupRouters() *mux.Router {
	router := mux.NewRouter()
	// router.NewRoute()
	router.HandleFunc("/getmessages",getMessages).Methods(("GET"))
	router.HandleFunc("/sendmessages",postMessages).Methods(("POST"))
	return router
}

// func getMessages(w http.ResponseWriter,r *http.Request){}
// func postMessages(w http.ResponseWriter,r *http.Request){}