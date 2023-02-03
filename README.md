# dotfiles

This repository synchronizes dotfiles across machines.

## Setup

To setup the repository, execute the following commands:

```shell
./setup
```

## Running

To run the script, execute the following command:

```shell
python3.10 util.py
```

## Testing

To run the tests, execute the following command:

```shell
pytest --cov --cov-report=html -n auto
```

## Linting

To run the linter, execute the following command:

```shell
pylint dotfiles tests
```
