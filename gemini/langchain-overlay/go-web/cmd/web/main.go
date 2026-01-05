package main

import (
	"context"
	"flag"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/tmc/langchaingo/llms"
	"github.com/tmc/langchaingo/llms/googleai"
)

// 🔥 FILL THIS OUT FIRST! 🔥
// Get your Gemini API key by:
// - Selecting "Add Gemini API" in the "Firebase Studio" panel in the sidebar
// - Or by visiting https://g.co/ai/idxGetGeminiKey
// This can also be provided as the API_KEY environment variable.
//
// NOTE: Make sure to `Hard Restart` the web preview in IDX
// when updating this variable, using `> Firebase Studio: Hard Restart`.
var apiKey = "TODO"

func usage() {
	fmt.Fprintf(flag.CommandLine.Output(), "usage: web [options]\n")
	flag.PrintDefaults()
	os.Exit(2)
}

var (
	addr = flag.String("addr", "localhost:8080", "address to serve")
)

func generateHandler(w http.ResponseWriter, r *http.Request, llm *googleai.GoogleAI) {
	if apiKey == "TODO" {
		http.Error(w, "Error: To get started, get an API key at https://aistudio.google.com/app/apikey and enter it in cmd/web/main.go and then hard restart the preview", http.StatusInternalServerError)
		return
	}

	image, prompt := r.FormValue("chosen-image"), r.FormValue("prompt")
	imgData, err := os.ReadFile(filepath.Join("static", "images", filepath.Base(image)))
	if err != nil {
		log.Printf("Unable to read image %s: %v\n", image, err)
		http.Error(w, "Error: unable to generate content", http.StatusInternalServerError)
		return
	}

	// Create the image part
	imageMimeType := "image/jpeg"
	imagePart := llms.BinaryContent{
		MIMEType: imageMimeType,
		Data:     imgData,
	}

	// Create the text part
	textPart := llms.TextContent{
		Text: prompt,
	}

	// Combine the parts into a MessageContent
	content := []llms.MessageContent{
		{
			Role: llms.ChatMessageTypeHuman,
			Parts: []llms.ContentPart{
				imagePart,
				textPart,
			},
		},
	}

	// Generate Content using the LLM
	response, err := llm.GenerateContent(
		r.Context(),
		content,
		llms.WithModel("gemini-2.0-flash"),) // or gemini

    // Handle error
	if err != nil {
		log.Printf("Error generating content: %v\n", err)
		http.Error(w, "Error: unable to generate content", http.StatusInternalServerError)
		return
	}

	// Handle Response
	if len(response.Choices) > 0 {
		generatedText := response.Choices[0].Content
		fmt.Fprintf(w, "%s", generatedText)
	} else {
		fmt.Printf("No content is generated")
	}
}

type Page struct {
	Images []string
}

var tmpl = template.Must(template.ParseFiles("static/index.html"))

func indexHandler(w http.ResponseWriter, r *http.Request) {
	// Load all baked goods images from the static/images directory.
	matches, err := filepath.Glob(filepath.Join("static", "images", "baked_goods_*.jpeg"))
	if err != nil {
		log.Printf("Error loading baked goods images: %v", err)
	}
	var page = &Page{Images: make([]string, len(matches))}
	for i, match := range matches {
		page.Images[i] = filepath.Base(match)
	}
	switch r.URL.Path {
	case "/":
		err = tmpl.Execute(w, page)
		if err != nil {
			log.Printf("Template execution error: %v", err)
		}
	}
}

func main() {
	// Parse flags.
	flag.Usage = usage
	flag.Parse()

	// Parse and validate arguments (none).
	args := flag.Args()
	if len(args) != 0 {
		usage()
	}

	// Get the Gemini API key from the environment.
	if key := os.Getenv("API_KEY"); key != "" {
		apiKey = key
	}

	llm, err := googleai.New(context.Background(), googleai.WithAPIKey(apiKey))
	if err != nil {
		log.Fatal(err)
	}
	// Serve static files and handle API requests.
	fs := http.FileServer(http.Dir("static"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))
	http.HandleFunc("/api/generate", func(w http.ResponseWriter, r *http.Request) { generateHandler(w, r, llm) })
	http.HandleFunc("/", indexHandler)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
