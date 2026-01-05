import { genkit } from 'genkit/beta';
import { googleAI, gemini20Flash } from '@genkit-ai/googleai';
import { createWeatherTool, createHackerNewsTool, createHackerNewsSummaryTool } from './tools'

export const ai = genkit({
	plugins: [googleAI()],
	model: gemini20Flash,
});

// Define tools for chat 
const weatherTool = createWeatherTool(ai);
const hackerNewsTool = createHackerNewsTool(ai);
const hackerNewsSummaryTool = createHackerNewsSummaryTool({ 
	hackerNewsTool, 
	ai 
});

// New! Genkit gives you persistent chat sessions.
// You can still call ai.definePrompt() to create an executable prompt
export const chat = ai.chat({
	model: gemini20Flash,
	system: `You are a helpful assistant. If the user asks you what you can do, respond with your tools and creative uses.`,
	tools: [weatherTool, hackerNewsSummaryTool],
});
