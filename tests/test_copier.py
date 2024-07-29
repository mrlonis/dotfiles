"""This file contains the tests for the copier module."""
from os import getenv
from pathlib import Path

from dotfiles.constants import get_file_inputs
from dotfiles.copier import copy_dot_files
from dotfiles.models import FileMode


def test_copier():
    """Test the copy_dot_files function."""
    print("test_copier(): Starting...")
    source_folder = getenv("HOME")
    assert source_folder is not None
    destination_folder = Path("./files").resolve()
    overwrite = False
    log = True
    copy_dot_files(
        source_folder=source_folder,
        destination_folder=destination_folder,
        filenames=get_file_inputs(file_mode=FileMode.COPY),
        overwrite=overwrite,
        log=log,
        test=True,
    )
    print("test_copier(): Finished.")
