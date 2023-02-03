import os
from pathlib import Path

from dotfiles.constants import FILENAMES
from dotfiles.copier import copy_dot_files


def test_copier():
    print("test_copier(): Starting...")
    source_folder = os.getenv("HOME")
    assert source_folder is not None
    destination_folder = Path("./files").resolve()
    overwrite = False
    log = True
    copy_dot_files(
        source_folder=source_folder,
        destination_folder=destination_folder,
        filenames=FILENAMES,
        overwrite=overwrite,
        log=log,
        test=True,
    )
    print("test_copier(): Finished.")
