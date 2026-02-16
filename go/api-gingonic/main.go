
package main

import (
    "fmt"
    "log"
    "net/http"
    "os"

    "github.com/gin-gonic/gin"
)

func main() {
log.Print("starting server...")
    r := gin.Default()
    r.SetTrustedProxies(nil)
    r.GET("/", handler)

    // Determine port for HTTP service.
    port := os.Getenv("PORT")
    if port == "" {
        port = "3000"
        log.Printf("defaulting to port %s", port)
    }

    // Start HTTP server.
    log.Printf("listening on http://localhost:%s", port)
    if err := r.Run(":" + port); err != nil {
        log.Fatal(err)
    }
}

func handler(c *gin.Context) {
    name := os.Getenv("NAME")
    if name == "" {
        name = "World"
    }
    c.String(http.StatusOK, fmt.Sprintf("Hello %s!\n", name))
}
