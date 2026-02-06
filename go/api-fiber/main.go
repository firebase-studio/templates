

package main

import (
	"fmt"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
)

func main() {
	// Create a new Fiber app
	app := fiber.New()

	// Define a route for the root path '/'
	app.Get("/", func(c *fiber.Ctx) error {
		name := os.Getenv("NAME")
		if name == "" {
			name = "world"
		}
		// Send a string response
		return c.SendString(fmt.Sprintf("Hello %s!\n", name))
	})

	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	log.Printf("Starting server on port %s", port)

	// Start the server and listen on the specified port.
	// This is a blocking call, so it will log errors if the server fails to start.
	log.Fatal(app.Listen(":" + port))
}
