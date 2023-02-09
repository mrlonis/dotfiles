#!/bin/bash
# pip-compile -U --resolver=backtracking --output-file=requirements.txt requirements.in
# pip-compile -U --resolver=backtracking --output-file=requirements-test.txt requirements-test.in
# pip-compile -U --resolver=backtracking --output-file=requirements-dev.txt requirements-dev.in

pip-compile -U --output-file=requirements.txt requirements.in
pip-compile -U --output-file=requirements-test.txt requirements-test.in
pip-compile -U --output-file=requirements-dev.txt requirements-dev.in
