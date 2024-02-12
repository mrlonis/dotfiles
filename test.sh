#!/bin/bash
poetry run flake8 dotfiles tests util.py
poetry run pylint dotfiles tests util.py
poetry run pytest --cov --cov-report=html -n auto
