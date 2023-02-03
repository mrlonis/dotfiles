import os

from dotfiles.constants import FILENAMES
from dotfiles.symlinker import create_symlinks


def test_symlinker():
    print("test_symlinker(): Starting...")
    destination_folder = os.getenv("HOME")
    assert destination_folder is not None
    filenames = FILENAMES
    log = True
    create_symlinks(
        destination_folder=destination_folder,
        filenames=filenames,
        log=log,
        test=True,
    )
    print("test_symlinker(): Finished.")
