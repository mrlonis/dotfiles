import sys

from dotfiles.models import FileInput, FileMode

GIT_CONFIG_FILENAME = ".gitconfig"
WSL_GIT_CONFIG_FILENAME = f"wsl{GIT_CONFIG_FILENAME}"

FILENAMES = [
    "fun.py",
    "setup_all.sh",
    "requirements.in",
    "requirements.txt",
    ".bashrc",
    GIT_CONFIG_FILENAME,
    ".netrc",
    ".npmrc",
    ".profile",
    ".pypirc",
    ".zshrc",
    "git_pull_all.sh",
    ".aws",
    ".mrlonis_after_setup.sh",
]


def get_file_inputs(file_mode: FileMode):
    """Get the list of FileInput objects."""
    file_inputs = []

    for filename in FILENAMES:
        file_input = FileInput(filename=filename)
        if filename == GIT_CONFIG_FILENAME:
            _handle_git_ignore(file_mode=file_mode, file_input=file_input)
        elif filename == ".aws":
            file_input = _handle_aws(file_mode=file_mode, file_input=file_input)

        if file_input:
            file_inputs.append(file_input)

    return file_inputs


def _handle_git_ignore(file_mode: FileMode, file_input: FileInput):
    if sys.platform.startswith("linux"):
        if file_mode == FileMode.COPY:
            file_input.destination_filename = WSL_GIT_CONFIG_FILENAME
        elif file_mode == FileMode.SYMLINK:
            file_input.filename = WSL_GIT_CONFIG_FILENAME
            file_input.destination_filename = GIT_CONFIG_FILENAME
        else:
            raise ValueError(f"Invalid file_mode: {file_mode}")


def _handle_aws(file_mode: FileMode, file_input: FileInput):
    if sys.platform.startswith("linux"):
        if file_mode == FileMode.SYMLINK:
            # We don't want to symlink the .aws folder on WSL since it is managed
            # by the Windows Docker Desktop as a symlink to the Windows .aws folder.
            return None
    return file_input
