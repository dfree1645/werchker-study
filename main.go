package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	e := gin.Default()

	e.GET("/", func(c *gin.Context) {
		c.String(200, "test server")
	})

	e.Run(":8080")
}
