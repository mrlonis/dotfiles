#!/bin/bash
pip-compile -U requirements.in
pip-compile -U requirements-test.in
pip-compile -U requirements-dev.in
