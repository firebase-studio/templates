# Agent Development Kit (ADK) Template

This template provides a starting point for building AI agents with the Agent Development Kit (ADK) in Firebase Studio. It includes a sample Python agent and a pre-configured environment.

## Requirements

1.  An active Google Cloud project with the Vertex AI API enabled.
2.  A configured authentication method to access Google Cloud services (see below).

## Getting Started with Python

This template is optimized for a fast Python development experience.

### 1. Configure Authentication

You can connect to Google's AI services using either a simple API key or by authenticating with your Google Cloud account.

**Option 1: Use an API Key (Easiest)**

1.  Get your Gemini API key from [Google AI Studio](https://g.co/ai/idxGetGeminiKey).
2.  Open the `multi_tool_agent/.env.local` file.
3.  Replace `PASTE_YOUR_ACTUAL_API_KEY_HERE` with your key. The file should look like this:

    ```bash
    # multi_tool_agent/.env.local
    # Use Google AI Studio API
    GOOGLE_GENAI_USE_VERTEXAI=FALSE
    GOOGLE_API_KEY=PASTE_YOUR_ACTUAL_API_KEY_HERE
    ```

**Option 2: Use Your Google Cloud Account (More Powerful)**

1.  Open a terminal in Firebase Studio.
2.  Log in to Google Cloud and set your project:
    ```bash
    export GOOGLE_CLOUD_PROJECT="your-gcp-project-id"
    gcloud auth login --update-adc --brief --quiet
    gcloud config set project $GOOGLE_CLOUD_PROJECT
    ```
3.  Open the `multi_tool_agent/.env.local` file and modify it to use Vertex AI. The file should look like this:
    ```bash
    # multi_tool_agent/.env.local
    # Use Google Cloud Vertex AI API
    GOOGLE_GENAI_USE_VERTEXAI=TRUE
    GOOGLE_CLOUD_PROJECT="your-gcp-project-id"
    GOOGLE_CLOUD_LOCATION="us-central1"
    ```

> **Note:** Environment variables are loaded per-agent. If you create a new agent, you will need to provide it with its own `.env.local` file.

### 2. Run the Agent

This template includes a `devserver.sh` script that activates the environment and starts the ADK web server, which you can access in the Previews panel.

To start the server, run the following command in the terminal:

```bash
./devserver.sh
```

Alternatively, you can run the `adk` commands manually:

```bash
# To run the interactive web UI
source .venv/bin/activate
adk web multi_tool_agent

# To run the command-line interface
source .venv/bin/activate
adk run multi_tool_agent
```

### 3. Next Steps

*   Explore the included `multi_tool_agent` to understand how a basic agent is structured.
*   Copy and rename the `multi_tool_agent` directory to create new agents.
*   Check out the official [ADK Samples](https://github.com/google/adk-samples) for more advanced examples.
    ```bash
    cp -rf adk-samples/python/agents/* .
    ```
*   For a robust CI/CD environment, consider using the [Agent Starter Pack](https://github.com/GoogleCloudPlatform/agent-starter-pack/).
    ```bash
    uvx agent-starter-pack create my-new-emails
    ```

---

## Java Development

This template is primarily set up for Python. For a detailed guide on getting started with the ADK for Java, please see the [official documentation](https://google.github.io/adk-docs/get-started/quickstart-java/).

## Key ADK Concepts

*   **Agents:** The fundamental building blocks of the ADK. Agents are autonomous entities that can perceive their environment, make decisions, and take actions to achieve their goals.
*   **Tools:** Functions that agents can use to interact with the outside world. Tools can be used to access APIs, databases, or any other external service.
*   **Sessions:** A mechanism for managing the state of an agent and for storing information in long-term memory.
*   **Multi-agent Systems:** The ADK supports the creation of multi-agent systems, where multiple agents can collaborate to solve complex problems.

## Resources

*   **ADK Documentation:** [https://google.github.io/adk-docs/](https://google.github.io/adk-docs/)
*   **ADK Videos:** [https://www.youtube.com/playlist?list=PLOU2XLYxmsIIAPgM8FmtEcFTXLLzmh4DK](https://www.youtube.com/playlist?list=PLOU2XLYxmsIIAPgM8FmtEcFTXLLzmh4DK)
*   **ADK on GitHub:** [Python](https://github.com/google/adk-python) | [Java](https://github.com/google/adk-java) | [Samples](https://github.com/google/adk-samples)
