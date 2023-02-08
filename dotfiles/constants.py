import sys

from dotfiles.models import FileInput, FileMode

FILENAMES = [
    "fun.py",
    "setup_all.sh",
    "requirements.in",
    "requirements.txt",
    ".bashrc",
    ".gitconfig",
    ".netrc",
    ".npmrc",
    ".profile",
    ".pypirc",
    ".zshrc",
    "git_pull_all.sh",
    ".aws",
]


def get_file_inputs(file_mode: FileMode):
    """Get the list of FileInput objects."""
    file_inputs = []

    for filename in FILENAMES:
        file_input = FileInput(filename=filename)

        if filename == ".gitconfig":
            if sys.platform.startswith("linux"):
                if file_mode == FileMode.COPY:
                    file_input.destination_filename = "wsl.gitconfig"
                elif file_mode == FileMode.SYMLINK:
                    file_input.filename = "wsl.gitconfig"
                    file_input.destination_filename = ".gitconfig"
                else:
                    raise ValueError(f"Invalid file_mode: {file_mode}")

        file_inputs.append(file_input)

    return file_inputs
