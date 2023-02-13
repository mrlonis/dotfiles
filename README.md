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

## Brew Packages

### shfmt

To format shell files, install `shfmt` with brew:

```shell
brew install shfmt
```

and then run the following command to format all shell files in the repo:

```shell
shfmt -l -w setup_python_app.sh
```

### shellcheck

To lint shell files, install `shellcheck` with brew:

```shell
brew install shellcheck
```

and then run the following command to lint a shell file changing out the file name/path as needed:

```shell
shellcheck setup_python_app.sh
```

#### shellcheck VS Code Extension

To get integrated shellcheck linting in VS Code, install the [shellcheck extension](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)

### Ruby

```shell
brew install rbenv ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zprofile
echo 'eval "$(rbenv init -)"' >> ~/.zprofile
rbenv install 3.2.1
rbenv global 3.2.1
rbenv rehash
gem update --system
gem install mdl
```

#### Markdownlint

```shell
gem install mdl
```
