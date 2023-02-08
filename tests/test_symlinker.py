from os import getenv

from dotfiles.constants import get_file_inputs
from dotfiles.models import FileMode
from dotfiles.symlinker import create_symlinks


def test_symlinker():
    print("test_symlinker(): Starting...")

    destination_folder = getenv("HOME")
    assert destination_folder is not None
    log = True
    create_symlinks(
        destination_folder=destination_folder,
        filenames=get_file_inputs(file_mode=FileMode.SYMLINK),
        log=log,
        test=True,
    )
    print("test_symlinker(): Finished.")
