"""Exercise the batch updater only inside disposable GitHub directories."""

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
if [[ "$1" == -c ]]; then shift 2; fi
operation=$1
if [[ "$1" == branch && "$2" == --show-current ]]; then operation=current-branch; fi
printf '%s|%s\\n' "${PWD##*/}" "$operation" >> "$GIT_TEST_LOG"
if [[ "${PWD##*/}" == a-failing && "$operation" == "$GIT_TEST_FAILURE" ]]; then
    exit 42
fi
case "$operation" in
    symbolic-ref) printf 'refs/remotes/origin/main\\n' ;;
    current-branch) printf 'updates\\n' ;;
    for-each-ref) printf 'refs/heads/main\\nrefs/heads/stale-one\\nrefs/heads/stale-two\\n' ;;
    ls-remote) printf 'abcdef\\trefs/heads/main\\n' ;;
    remote|switch|fetch|merge|submodule|branch) ;;
    *) exit 99 ;;
esac
"""


UPDATE_STEPS = ["fetch", "remote", "symbolic-ref", "current-branch", "switch", "merge", "submodule"]
CLEANUP_STEPS = ["ls-remote", "for-each-ref", "branch"]


@pytest.mark.parametrize(
    ("force_cleanup", "failure"),
    [(False, step) for step in ["", *UPDATE_STEPS]] + [(True, step) for step in ["", *UPDATE_STEPS, *CLEANUP_STEPS]],
)
def test_repository_failure_isolation(tmp_path, force_cleanup, failure):
    """Stop at each failed operation but fully process the next repository."""
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

    expected = UPDATE_STEPS + (CLEANUP_STEPS + ["branch"] if force_cleanup else [])
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


def git(cwd, env, *args):
    return subprocess.run(
        ["git", *args], cwd=cwd, env=env, check=True, capture_output=True, text=True, timeout=10
    ).stdout.strip()


def update(env, *args):
    return subprocess.run(
        ["/bin/bash", str(SCRIPT), *args],
        cwd=env["HOME"],
        env=env,
        check=False,
        capture_output=True,
        text=True,
        timeout=10,
    )


@pytest.fixture(name="clone")
def disposable_clone(tmp_path):
    home = tmp_path / "home with spaces"
    project = home / "GitHub" / "organization" / "project"
    project.parent.mkdir(parents=True)
    env = {
        "HOME": str(home),
        "PATH": os.environ["PATH"],
        "GIT_CONFIG_NOSYSTEM": "1",
        "GIT_ALLOW_PROTOCOL": "file",
        "GIT_AUTHOR_NAME": "Test",
        "GIT_AUTHOR_EMAIL": "test@example.org",
        "GIT_COMMITTER_NAME": "Test",
        "GIT_COMMITTER_EMAIL": "test@example.org",
    }
    origin = tmp_path / "origin.git"
    git(tmp_path, env, "init", "--bare", "-b", "master", str(origin))
    git(tmp_path, env, "clone", str(origin), str(project))
    git(project, env, "commit", "--allow-empty", "-m", "initial")
    git(project, env, "push", "-u", "origin", "master")
    return project, origin, env


def test_renamed_default_and_opt_in_cleanup(clone):
    project, origin, env = clone
    git(origin, env, "branch", "-m", "master", "release/stable")
    git(project, env, "switch", "-c", "work-in-progress")
    git(project, env, "commit", "--allow-empty", "-m", "unpublished")
    unpublished = git(project, env, "rev-parse", "HEAD")

    result = update(env)
    assert result.returncode == 0, result.stderr
    assert git(project, env, "branch", "--show-current") == "release/stable"
    assert git(project, env, "rev-parse", "HEAD") == git(origin, env, "rev-parse", "HEAD")
    assert git(project, env, "rev-parse", "work-in-progress") == unpublished
    assert git(project, env, "branch", "--list", "master")  # Upstream was deleted.

    # A restricted fetch leaves this branch out of refs/remotes/origin.
    git(project, env, "config", "remote.origin.fetch", "+refs/heads/release/*:refs/remotes/origin/release/*")
    git(origin, env, "branch", "keep-me")
    git(project, env, "branch", "keep-me")
    result = update(env, "1")
    assert result.returncode == 0, result.stderr
    assert git(project, env, "for-each-ref", "--format=%(refname:lstrip=2)", "refs/heads").splitlines() == [
        "keep-me",
        "release/stable",
    ]


def test_skip_non_repos_and_update_linked_worktree(clone, tmp_path):
    project, _, env = clone
    org = project.parent
    primary = tmp_path / "primary"
    project.rename(primary)
    git(primary, env, "switch", "-c", "updates")
    git(primary, env, "worktree", "add", "--detach", str(project))
    git(org, env, "init", "-b", "org-branch")
    (org / "ordinary directory").mkdir()
    (org / "invalid" / ".git").mkdir(parents=True)
    (org / "notes.txt").touch()
    (org.parent / "empty organization").mkdir()

    result = update(env, "0")
    assert result.returncode == 0, result.stderr
    assert result.stdout.splitlines()[0] == f"Updating {project}"
    for name in ("ordinary directory", "invalid", "notes.txt", "empty organization"):
        assert name not in result.stdout + result.stderr
    assert git(project, env, "branch", "--show-current") == "master"
    assert git(primary, env, "branch", "--show-current") == "updates"


def test_divergence_stops_before_cleanup(clone, tmp_path):
    project, origin, env = clone
    writer = tmp_path / "writer"
    git(tmp_path, env, "clone", str(origin), str(writer))
    git(writer, env, "commit", "--allow-empty", "-m", "remote change")
    git(writer, env, "push")
    git(project, env, "commit", "--allow-empty", "-m", "local change")
    git(project, env, "branch", "local-only")
    before = git(project, env, "rev-parse", "HEAD")

    result = update(env, "1")
    assert result.returncode == 1
    assert git(project, env, "rev-parse", "HEAD") == before
    assert git(project, env, "rev-parse", "local-only") == before


def test_fast_forward_uses_origin_default_even_with_another_upstream(clone, tmp_path):
    project, origin, env = clone
    git(project, env, "switch", "-c", "feature")
    git(project, env, "push", "-u", "origin", "feature")
    git(project, env, "branch", "--set-upstream-to=origin/feature", "master")
    writer = tmp_path / "writer"
    git(tmp_path, env, "clone", str(origin), str(writer))
    git(writer, env, "commit", "--allow-empty", "-m", "advance master")
    git(writer, env, "push")

    result = update(env)
    assert result.returncode == 0, result.stderr
    assert git(project, env, "branch", "--show-current") == "master"
    assert git(project, env, "rev-parse", "HEAD") == git(writer, env, "rev-parse", "HEAD")


def test_forced_remote_submodule_update(clone, tmp_path):
    project, _, env = clone
    upstream = tmp_path / "library"
    git(tmp_path, env, "init", "-b", "main", str(upstream))
    (upstream / "content").write_text("pinned")
    git(upstream, env, "add", "content")
    git(upstream, env, "commit", "-m", "initial")
    git(project, env, "submodule", "add", str(upstream), "library")
    git(project, env, "commit", "-am", "pin library")
    git(project, env, "push")
    git(project, env, "submodule", "deinit", "--force", "library")

    (upstream / "content").write_text("latest")
    git(upstream, env, "commit", "-am", "update library")
    result = update(env)
    assert result.returncode == 0, result.stderr
    content = project / "library" / "content"
    assert content.read_text() == "latest"
    content.write_text("local edit")
    result = update(env)
    assert result.returncode == 0, result.stderr
    assert content.read_text() == "latest"
