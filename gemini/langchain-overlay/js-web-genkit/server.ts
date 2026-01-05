import * as fs from 'fs/promises';
import { genkit, z } from 'genkit';
import express from "express";
import { ChatGoogleGenerativeAI } from '@langchain/google-genai'
import { ChatPromptTemplate, HumanMessagePromptTemplate, SystemMessagePromptTemplate } from '@langchain/core/prompts';
import { StringOutputParser } from '@langchain/core/output_parsers';
import { RunnableSequence } from '@langchain/core/runnables';

const port = process.env.PORT || 3000;

export const ai = genkit({
    plugins: [],
});

const model = new ChatGoogleGenerativeAI({
    model: "gemini-2.0-flash",
  });
const systemMessage = SystemMessagePromptTemplate.fromTemplate("Return a recipie in markdown format")
const userMessage = HumanMessagePromptTemplate.fromTemplate([
    {
        type: "text",
        text: "The user has asked: {userPrompt}"
    },
    {
        type: "image_url",
        image_url: "{photoUrl}",
    },
]);

  const prompt = ChatPromptTemplate.fromMessages([
    systemMessage,
    userMessage,
  ]);

  export const recipieWithContextFlow = ai.defineFlow(
    {
      name: 'recipieFlow', inputSchema: z.object({
        photoUrl: z.string(),
        userPrompt: z.string(),
      }), outputSchema: z.string()
    },
    async (inputs) => {
      const chain = RunnableSequence.from([
        prompt,
        model,
        new StringOutputParser(),
      ]);
  
      return await chain.invoke({
        userPrompt: inputs.userPrompt,
        photoUrl: inputs.photoUrl,
      });
    }
  );

async function createServer() {
    const app = express();
    app.use(express.static('static'));
    app.post("/api/generate", express.json(), async (req, res) => {
        const { image, userPrompt } = req.body;
        let imageUrl = `./static/images/${image}`;
        const imageBase64 = await fs.readFile(imageUrl, { encoding: 'base64' });

        const result = await recipieWithContextFlow({
            photoUrl: `data:image/jpeg;base64,${imageBase64}`,
            userPrompt: userPrompt
        });
        return res.send(result);
    });
    app.listen(port);
    console.log("Server started: http://localhost:" + port);
}

createServer();
