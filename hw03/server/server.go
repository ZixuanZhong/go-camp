package server

import (
	"hw03/config"

	"github.com/gin-gonic/gin"
)

var engine *gin.Engine

func Init() {
	config := config.GetConfig()
	engine := NewRouter()
	engine.Run(config.GetString("server.port"))
}

func Shutdown() {
	// stop engine
	return
}
