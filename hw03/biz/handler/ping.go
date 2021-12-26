package handler

import (
	"hw03/biz/model"

	"github.com/gin-gonic/gin"
)

func Ping(c *gin.Context) {
	c.JSON(200, model.User{
		ID:   12,
		Name: "abc",
	})
}
