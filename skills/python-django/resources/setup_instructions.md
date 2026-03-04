# Django Setup Instructions

This document provides instructions on how to set up and run a new Django project.

## 1. Prerequisites

- Python 3.8+
- pip (Python package installer)

## 2. Create a Virtual Environment

It is highly recommended to use a virtual environment to manage project dependencies.

```bash
python -m venv venv
source venv/bin/activate  # On Windows, use `venv\\Scripts\\activate`
```

## 3. Install Django

Install Django using pip:

```bash
pip install django
```

## 4. Create a Django Project

Use the `django-admin` command-line utility to create a new project.

```bash
django-admin startproject myproject .
```

This will create a `myproject` directory in your current directory.

## 5. Run the Development Server

Once the project is created, you can run the development server.

```bash
python manage.py runserver
```

The server will start on `http://127.0.0.1:8000/`.

## 6. Project Structure

A newly created Django project has the following structure:

```
.
├── manage.py
└── myproject
    ├── __init__.py
    ├── asgi.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py
```
