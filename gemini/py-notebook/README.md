# Gemini API with py-notebook

This sample demonstrates how to use the Gemini API with the Python SDK in a Jupyter Notebook. You'll learn how to interact with the Gemini model to get recipe ideas from images of baked goods.

## Getting Started

This project is configured to run in a Nix-based environment, which automatically handles the setup of necessary tools and dependencies.

When the workspace is first created, the following actions are performed:
1.  A Python virtual environment is created in the `.venv` directory.
2.  The required Python packages are installed from `requirements.txt` into the virtual environment.

### Dependencies

This project uses the following key technologies:

*   **[Python](https://www.python.org/doc/)**: The programming language used for the notebook.
*   **[Google Generative AI SDK for Python](https://pypi.org/project/google-genai/)**: The client library for accessing the Gemini API.
*   **[Pillow](https://pillow.readthedocs.io/en/stable/)**: A library for opening, manipulating, and saving many different image file formats.

The environment also includes the Jupyter and Python extensions for VS Code.

## Running the Application

1.  **Get an API Key**: Before you can use the Gemini API, you need to [get an API key](https://g.co/ai/idxGetGeminiKey).

2.  **Configure the API Key**:
    *   Open the `main.ipynb` notebook.
    *   In the first code cell, replace the placeholder `TODO` with your API key:
        ```python
        API_KEY = 'YOUR_API_KEY_HERE'
        ```

3.  **Run the Notebook**:
    *   Execute the cells in the `main.ipynb` notebook sequentially.
    *   You can modify the `prompt` variable to ask different questions about the images.
    *   You can also change which image is loaded by uncommenting one of the other `PIL.Image.open()` lines.

## Files

*   `main.ipynb`: The main Jupyter Notebook for this sample. It contains the Python code to interact with the Gemini API.
*   `requirements.txt`: This file lists the Python packages required to run the notebook, which are installed automatically when the environment is set up.
*   `baked_goods_1.jpg`, `baked_goods_2.jpg`, `baked_goods_3.jpg`: Sample images used in the notebook to generate recipes.
*   `.idx/dev.nix`: The Nix configuration file that defines the development environment, including the required packages and setup commands.

## References

*   **Python Documentation**: [https://www.python.org/doc/](https://www.python.org/doc/)
*   **Google Generative AI SDK**: [https://pypi.org/project/google-genai/](https://pypi.org/project/google-genai/)
*   **Gemini API Documentation**: [https://developers.generativeai.google/guide](https://developers.generativeai.google/guide)
