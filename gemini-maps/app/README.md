# Using the Gemini API and Google Maps Platform with TypeScript

This template provides a sample app demonstrating use of the Gemini API with multimodal inputs (images and text) and the Google Maps JavaScript API.

## Prerequisites

### Gemini API

In order for the Gemini API features to work, you'll need to add a Gemini API key as a local variable.

1. Open the Firebase Studio view by pressing Ctrl+Shift+P / Cmd+Shift+P and type "IDX focus", then select "IDX: Focus on Firebase Studio View"
2. Click on the "Gemini API" integration and authenticate.
3. Click "Get API Key" to get an API key.
4. Create or open a file named .env.local in the root directory. The .local suffix keeps secrets out of source control.
5. In the file, add the line: VITE_GEMINI_API_KEY="YOUR_API_KEY"
6. Replace YOUR_API_KEY with the API key you got in step 3.

### Google Maps Platform, Maps JavaScript API

In order for the Maps JavaScript API features to work, you'll need to add a Google Maps Platform API key as a local variable.

1. Open the Firebase Studio view by pressing Ctrl+Shift+P / Cmd+Shift+P and type "IDX focus", then select "IDX: Focus on Firebase Studio View"
2. Click on the "Google Maps Platform" integration.
3. Click "Enable APIs" to enable the Google Maps Platform APIs.
4. Click "Get API Key" to get an API key.
5. Create or open the file named .env.local in the root directory. The .local suffix keeps secrets out of source control.
6. In the file, add the line: VITE_MAPS_API_KEY="YOUR_API_KEY"
7. Replace YOUR_API_KEY with the API key you got in step 4.

## Google Maps Platform Code Assist MCP

This template comes pre-configured with the [Google Maps Platform Code Assist MCP](https://github.com/googlemaps/platform-ai/tree/main/packages/code-assist) server. This tool makes your Gemini AI assistant in Firebase Studio an expert on Google Maps Platform, allowing it to generate code and answer questions based on the latest official documentation and code samples.

## Features

Most of the code powering the features of this sample are in the `src/main.ts` file.

### Gemini API

- Image + text prompt: When the user selects an image and presses the "Where can I see this?" button, that image and a text prompt are sent to the Gemini API.
- Text-only prompt: The Gemini API is used to augment and refine the draft review of a destination.

### Google Maps Platform, Maps JavaScript API

- [Photorealistic 3D map (Experimental)](https://developers.google.com/maps/documentation/javascript/3d-maps-overview) in the Maps JavaScript API
- [Geocoding Service](https://developers.google.com/maps/documentation/javascript/geocoding), Maps JavaScript API
- [Nearby Search (New) in the Places Library](https://developers.google.com/maps/documentation/javascript/nearby-search), Maps JavaScript API
- [Extended Component Library (beta)](https://developers.google.com/maps/documentation/javascript/libraries-open-source#web-components) for the Maps JavaScript API providing the split layout and the Place Overview components.
