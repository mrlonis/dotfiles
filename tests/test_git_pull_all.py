"""Exercise repository failure isolation without invoking real Git operations."""

import os
import subprocess
from pathlib import Path

import pytest

SCRIPT = Path(__file__).resolve().parents[1] / "files" / "git_pull_all.sh"
MOCK_GIT = """#!/bin/bash
if [[ "$1" == -C ]]; then
    printf 'true\\n'
    exit 0
fi
operation=$1
if [[ "$1" == for-each-ref && "$4" == refs/remotes/origin ]]; then
    operation=remote-refs
fi
printf '%s|%s\\n' "${PWD##*/}" "$operation" >> "$GIT_TEST_LOG"
if [[ "${PWD##*/}" == a-failing && "$operation" == "$GIT_TEST_FAILURE" ]]; then
    exit 42
fi
case "$1" in
    remote) printf '  HEAD branch: main\\n' ;;
    rev-parse) printf 'updates\\n' ;;
    for-each-ref)
        if [[ "$4" == refs/remotes/origin ]]; then
            printf 'origin/main\\n'
        elif [[ "$3" == '%(refname:short)' ]]; then
            printf 'main\\nstale-one\\nstale-two\\n'
        else
            printf 'refs/heads/stale-one [gone]\\nrefs/heads/stale-two [gone]\\n'
        fi
        ;;
    checkout|fetch|pull|submodule|branch) ;;
    *) exit 99 ;;
esac
"""


@pytest.mark.parametrize("force_cleanup", [False, True])
@pytest.mark.parametrize(
    "failure",
    ["", "remote", "rev-parse", "checkout", "fetch", "pull", "submodule", "for-each-ref", "remote-refs", "branch"],
)
def test_repository_failure_isolation(tmp_path, force_cleanup, failure):
    """Stop at each failed operation but fully process the next repository."""
    if failure == "remote-refs" and not force_cleanup:
        pytest.skip("Only force cleanup queries origin's branch list separately")

    test_home = tmp_path / "home with spaces"
    org = test_home / "GitHub" / "organization"
    for name in ("a-failing", "b-healthy"):
        repo = org / name
        (repo / ".git").mkdir(parents=True)
        (repo / ".gitmodules").touch()
    (org / "not-a-repository").mkdir()
    (test_home / "GitHub" / "not-an-organization").touch()

    mock_bin = tmp_path / "bin"
    mock_bin.mkdir()
    mock_git = mock_bin / "git"
    mock_git.write_text(MOCK_GIT)
    mock_git.chmod(0o755)
    log = tmp_path / "git.log"
    env = {
        **os.environ,
        "HOME": str(test_home),
        "PATH": f"{mock_bin}{os.pathsep}/usr/bin{os.pathsep}/bin",
        "GIT_TEST_LOG": str(log),
        "GIT_TEST_FAILURE": failure,
    }
    result = subprocess.run(
        ["/bin/bash", str(SCRIPT), str(int(force_cleanup))],
        cwd=tmp_path,
        env=env,
        capture_output=True,
        text=True,
        check=False,
        timeout=10,
    )

    expected = ["remote", "rev-parse", "checkout", "fetch", "pull", "submodule", "for-each-ref"]
    if force_cleanup:
        expected.append("remote-refs")
    expected.extend(["branch", "branch"])
    operations = [line.split("|", 1) for line in log.read_text().splitlines()]
    failing_operations = [operation for repo, operation in operations if repo == "a-failing"]
    assert [operation for repo, operation in operations if repo == "b-healthy"] == expected
    assert {repo for repo, _ in operations} == {"a-failing", "b-healthy"}
    assert "not-a-repository" not in result.stdout
    if failure:
        assert result.returncode == 1
        assert failing_operations == expected[: expected.index(failure) + 1]
        assert f"Failed to update repository: {org / 'a-failing'}" in result.stderr
        assert "b-healthy" not in result.stderr
    else:
        assert result.returncode == 0
        assert failing_operations == expected
        assert not result.stderr
