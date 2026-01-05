const container = document.querySelector("#prettier-version");
const promptText = document.querySelector("#prompt-text");
const promptTitle = document.querySelector("#prompt-title");
const aiButton = document.querySelector("#ai-button");
const aiButtonStream = document.querySelector("#ai-button-stream");
const clearButton = document.querySelector("#clear");
const outputHTML = document.querySelector("#ai-output");
const outputToneHTML = document.querySelector("#ai-output-tone");
const validateModel = document.querySelector("#validate-model");
const modelWrapper = document.querySelector("#model-wrapper");
const generateTitleButton = document.querySelector("#generate-title");
const rewriteButton = document.querySelector("#rewrite-review");
const toxicityButton = document.querySelector("#check-toxicity");

import { GoogleGenAI } from "@google/genai";
import { marked } from "https://esm.run/marked";

const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY;

// Function to display a loading state
function loadingState(message) {
  return `<section class="loading-container">
    <div class="loading">
      <span class="loading-dot"></span>
      <span class="loading-dot"></span>
      <span class="loading-dot"></span>
    </div> ${message}
  </section>`;
}

// Function to check for built-in prompting support
async function checkBuiltInPrompting() {
  if (
    window.model &&
    (await window.model.canCreateGenericSession()) === "readily"
  ) {
    console.log("Built-in prompting supported.");
    return true;
  } else {
    console.log(
      "Built-in prompting not supported. Falling back to Gemini API."
    );
    return false;
  }
}

// Function to update the visibility of the clear button
function updateClearButtonVisibility() {
  const noOutput = outputHTML.innerHTML.includes("(Results will be here)");
  clearButton.style.display = noOutput ? "none" : "block";
}
document.addEventListener("DOMContentLoaded", updateClearButtonVisibility);
outputHTML.addEventListener("DOMSubtreeModified", updateClearButtonVisibility);
clearButton.addEventListener("click", () => {
  outputHTML.innerHTML = `<span class="ai-output-placeholder">(Results will be here)</span>`;
  outputToneHTML.innerHTML = "";
  updateClearButtonVisibility();
});

// Event listeners for buttons
aiButton.addEventListener("click", () => runModel(false)); // Non-streaming
aiButtonStream.addEventListener("click", () => runModel(true)); // Streaming
clearButton.addEventListener("click", () => {
  outputHTML.innerHTML = `<span class="ai-output-placeholder">(Results will be here)</span>`;
  outputToneHTML.innerHTML = "";
});

generateTitleButton.addEventListener("click", generateReviewTitle);

async function generateReviewTitle() {
  outputHTML.innerHTML = loadingState("Generating title...");

  const hasBuiltInPrompting = await checkBuiltInPrompting();
  const reviewText = promptText.value;
  const placeName = localStorage.getItem("placeName") || "";

  if (hasBuiltInPrompting) {
    // Use built-in prompting
    let session = await window.model.createGenericSession();
    const title = await session.execute(
      `Generate a catchy title for this travel review: ${reviewText} to ${placeName}`
    );
    promptTitle.value = title;
    outputHTML.innerHTML = `<h2>${promptTitle.value}</h2><p>${reviewText}</p>`;
  } else {
    // Fallback to Gemini API
    const genAI = new GoogleGenAI({ apiKey:GEMINI_API_KEY });
   
    const result = await genAI.models.generateContent({
      model: "gemini-2.0-flash",
      contents: [
        `Generate a catchy title for this travel review: ${reviewText} to ${placeName}`,
      ],
    }
      );
    promptTitle.value = result.text;
    outputHTML.innerHTML = `<h2>${promptTitle.value}</h2><p>${reviewText}</p>`;
  }
}

rewriteButton.addEventListener("click", rewriteForReadability);
async function rewriteForReadability() {
  outputHTML.innerHTML = loadingState("Summarizing review...");

  const hasBuiltInPrompting = await checkBuiltInPrompting();
  const reviewText = promptText.value;
  const placeName = localStorage.getItem("placeName") || "";

  if (hasBuiltInPrompting) {
    // Use built-in prompting
    let session = await window.model.createGenericSession();
    const rewrittenText = await session.execute(
      `Summarize this text, first person: ${reviewText} for a trip to ${placeName}`
    );
    // promptText.value = rewrittenText;
    // outputHTML.innerHTML = rewrittenText;
    outputHTML.innerHTML = `<h2>${promptTitle.value}</h2><p>${rewrittenText}</p>`;
  } else {
    // Fallback to Gemini API
    const genAI = new GoogleGenAI({ apiKey:GEMINI_API_KEY });
   
    const result = await genAI.models.generateContent({
      model: "gemini-2.0-flash",
      contents: [
        `Summarize this text, first person: ${reviewText} for a trip to ${placeName}`,
      ],
    }
      );
    // promptText.value = result.response.text();
    // outputHTML.innerHTML = result.response.text();
    outputHTML.innerHTML = `<h2>${
      promptTitle.value
    }</h2><p>${result.text}</p>`;
  }
}

// Main function to run the model (built-in or Gemini API)
async function runModel(streaming) {
  const hasBuiltInPrompting = await checkBuiltInPrompting();

  if (hasBuiltInPrompting) {
    // Use built-in prompting
    runBuiltInAIModel(streaming);
  } else {
    // Fallback to Gemini API
    await runGeminiAPIModel(streaming);
  }
}

toxicityButton.addEventListener("click", checkToxicity);
async function checkToxicity() {
  const reviewText = promptText.value;
  outputToneHTML.innerHTML = loadingState("Checking tone...");

  const hasBuiltInPrompting = await checkBuiltInPrompting();

  if (hasBuiltInPrompting) {
    // Use built-in prompting (assuming the model supports toxicity detection)
    let session = await window.model.createGenericSession();
    const toxicityLevel = await session.execute(
      `Analyze the toxicity level of this text: ${reviewText}`
    );
    outputToneHTML.innerHTML = `<div class="tone-info">Tone: ${toxicityLevel}</div>`; // Or display in a more user-friendly way
  } else {
    // Fallback to Perspective API (requires additional setup)
    // You'll need to set up the Perspective API and include the library
    // For demonstration, let's assume you have a function `analyzeToxicity(text)`
    // const toxicityScore = await analyzeToxicity(reviewText);
    // outputHTML.innerHTML = (`Tone Score: ${toxicityScore}`); // Or display in a more user-friendly way

    // Fallback to Gemini API
    const genAI = new GoogleGenAI({ apiKey:GEMINI_API_KEY });
   
    const result = await genAI.models.generateContent({
      model: "gemini-2.0-flash",
      contents: [
        `Analyze the toxicity level of this text:: ${reviewText}`,
      ],
    }
      );
   
    outputToneHTML.innerHTML = `<div class="tone-info">Tone: ${result.text}</div>`;
  }
}

// Function to run the built-in AI model
async function runBuiltInAIModel(streaming) {
  let builtInsession = await window.model.createGenericSession();
  outputHTML.innerHTML = "Generating answer...Please wait...";

  if (streaming) {
    // Streaming result
    const stream = builtInsession.executeStreaming(promptText.value);
    const reader = stream.getReader();
    while (true) {
      const { value, done } = await reader.read();
      if (done) {
        break;
      }
      outputHTML.innerHTML = value;
    }
  } else {
    // Non-streaming result
    const result = await builtInsession.execute(promptText.value);
    outputHTML.innerHTML = marked.parse(result);
  }
}

// Function to run the Gemini API model
async function runGeminiAPIModel(streaming) {
  const genAI = new GoogleGenAI({ apiKey:GEMINI_API_KEY });
  const model = await genAI.getGenerativeModel({ model: "gemini-pro" });
  outputHTML.innerHTML = "Generating answer...Please wait...";

  if (streaming) {
    // Streaming result
    const result = await genAI.models.generateContentStream([promptText.value]);
    for await (const chunk of result.stream) {
      const chunkText = chunk.text();
      outputHTML.innerHTML = marked.parse(chunkText);
      scrollToDocumentBottom();
    }
  } else {
    // Non-streaming result
    const result = await genAI.models.generateContent({
      model: "gemini-2.0-flash",
      contents: [
        promptText.value,
      ],
    }
      );
    outputHTML.innerHTML = marked.parse(result.text);
  }
}

// Initial check for built-in prompting support on page load
checkBuiltInPrompting().then((hasBuiltInPrompting) => {
  if (!hasBuiltInPrompting) {
    //validateModel.innerHTML = `<h3>Built-in prompting not supported. Using Gemini API.</h3>`;
  }
});
