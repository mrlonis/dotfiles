# dotfiles

This repository synchronizes dotfiles across machines.

## Setup

To setup the repository, run `./setup` and activate the virtual environment the script tells you to.

## Running

To run the dotfiles synchronizer, execute the following command in the virtual environment:

```shell
python util.py
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

## Printing Links in Terminal

```shell
ls -lhaF | grep ^l
```
