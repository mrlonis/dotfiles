#!/bin/bash
poetry run flake8 dotfiles tests util.py
poetry run pylint dotfiles tests util.py
poetry run pydocstyle dotfiles tests util.py
poetry run bandit -c pyproject.toml -r .
poetry run pytest --cov --cov-report=html -n auto
