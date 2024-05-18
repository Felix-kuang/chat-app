package api

import (
	"encoding/json"
	"net/http"
	"time"

	"felix/chat-app/pkg/db"
)

// type Message struct {
// 	Username  string    `json:"username"`
// 	Text      string    `json:"text"`
// 	Timestamp time.Time `json:"timestamp"`
// }

func getMessages(w http.ResponseWriter, r *http.Request) {
	messages, err := db.GetMessages()
	if err != nil {
		http.Error(w, "Failed to retrieve messages from database", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(messages)
}

func postMessages(w http.ResponseWriter, r *http.Request) {
	var message db.Message

	if err := json.NewDecoder(r.Body).Decode(&message); err != nil{
		http.Error(w, "Failed to decode request body", http.StatusBadRequest)
		return
	}

	message.Timestamp = time.Now()
	

	if err := db.InsertMessage(message); err != nil {
		http.Error(w, "Failed to save message to database",http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
}
