#!/usr/bin/env python3
"""Prepare Giswater plugin releases.

Default mode is dry-run: it prints the file diffs and git commands without
touching the working tree. Use --execute to commit, tag, branch, push and
optionally create the GitHub release.
"""

from __future__ import annotations

import argparse
import difflib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request
from dataclasses import dataclass
from datetime import date
from pathlib import Path


REPO_URL = "https://github.com/Giswater/giswater_qgis_plugin"
GH_REPO = "Giswater/giswater_qgis_plugin"
DOCS_URL = "https://docs.giswater.org/latest/en/docs/index.html"


@dataclass(frozen=True)
class Version:
    major: int
    minor: int
    patch: int

    @property
    def text(self) -> str:
        return f"{self.major}.{self.minor}.{self.patch}"

    @property
    def tag(self) -> str:
        return f"v{self.text}"

    @property
    def release_branch(self) -> str:
        return f"release/{self.major}.{self.minor}"

    @property
    def is_minor_release(self) -> bool:
        return self.patch == 0

    @property
    def next_minor(self) -> "Version":
        return Version(self.major, self.minor + 1, 0)

    @property
    def next_patch(self) -> "Version":
        return Version(self.major, self.minor, self.patch + 1)


@dataclass
class PlannedChange:
    path: Path
    old_text: str
    new_text: str

    @property
    def changed(self) -> bool:
        return self.old_text != self.new_text


class ReleaseError(RuntimeError):
    pass


def parse_version(raw: str) -> Version:
    match = re.fullmatch(r"v?(\d+)\.(\d+)\.(\d+)", raw.strip())
    if not match:
        raise ReleaseError(f"Invalid version '{raw}'. Expected X.Y.Z or vX.Y.Z")
    return Version(*(int(part) for part in match.groups()))


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def run(
    args: list[str],
    *,
    cwd: Path,
    execute: bool,
    check: bool = True,
    capture: bool = False,
) -> str:
    rendered = " ".join(shell_quote(arg) for arg in args)
    if not execute:
        root = repo_root()
        if cwd != root:
            try:
                rel_cwd = cwd.relative_to(root)
                print(f"$ (cd {shell_quote(str(rel_cwd))} && {rendered})")
            except ValueError:
                print(f"$ (cd {shell_quote(str(cwd))} && {rendered})")
        else:
            print(f"$ {rendered}")
        return ""

    completed = subprocess.run(
        args,
        cwd=str(cwd),
        text=True,
        capture_output=capture,
        check=False,
    )
    if check and completed.returncode:
        stderr = completed.stderr.strip() if completed.stderr else ""
        stdout = completed.stdout.strip() if completed.stdout else ""
        detail = "\n".join(part for part in (stdout, stderr) if part)
        raise ReleaseError(f"Command failed: {rendered}\n{detail}")
    if capture:
        return completed.stdout.strip()
    return ""


def git(
    root: Path,
    *args: str,
    execute: bool = True,
    check: bool = True,
    capture: bool = False,
) -> str:
    return run(["git", *args], cwd=root, execute=execute, check=check, capture=capture)


def shell_quote(value: str) -> str:
    if re.fullmatch(r"[A-Za-z0-9_./:=@%+-]+", value):
        return value
    return "'" + value.replace("'", "'\"'\"'") + "'"


def current_branch(root: Path) -> str:
    return git(root, "branch", "--show-current", capture=True)


def ensure_clean(root: Path, *, execute: bool) -> None:
    status = git(root, "status", "--porcelain", capture=True)
    if not status:
        return
    if execute:
        raise ReleaseError("Working tree is not clean:\n" + status)
    print("WARNING: working tree is not clean; dry-run continues:\n" + status)


def ensure_expected_branch(root: Path, expected: str, *, execute: bool) -> None:
    branch = current_branch(root)
    if branch == expected:
        return
    message = f"Expected branch '{expected}', current branch is '{branch}'"
    if execute:
        raise ReleaseError(message)
    print(f"WARNING: {message}; dry-run continues")


def ref_exists(root: Path, ref: str) -> bool:
    subprocess_result = subprocess.run(
        ["git", "rev-parse", "--verify", "--quiet", ref],
        cwd=str(root),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    return subprocess_result.returncode == 0


def local_or_remote_branch_exists(root: Path, remote: str, branch: str) -> bool:
    return ref_exists(root, f"refs/heads/{branch}") or ref_exists(
        root, f"refs/remotes/{remote}/{branch}"
    )


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write_change(change: PlannedChange) -> None:
    if change.changed:
        change.path.write_text(change.new_text, encoding="utf-8")


def unified_diff(change: PlannedChange, root: Path) -> str:
    rel = change.path.relative_to(root)
    return "".join(
        difflib.unified_diff(
            change.old_text.splitlines(keepends=True),
            change.new_text.splitlines(keepends=True),
            fromfile=f"a/{rel}",
            tofile=f"b/{rel}",
        )
    )


def find_headings(changelog: str) -> list[tuple[str, int]]:
    pattern = re.compile(r"^## \[(Unreleased|\d+\.\d+\.\d+)\](?: - .*)?$", re.M)
    return [(match.group(1), match.start()) for match in pattern.finditer(changelog)]


def release_versions_from_headings(changelog: str) -> list[Version]:
    versions: list[Version] = []
    for name, _ in find_headings(changelog):
        if name != "Unreleased":
            versions.append(parse_version(name))
    return versions


def latest_released_version(changelog: str) -> Version:
    versions = release_versions_from_headings(changelog)
    if not versions:
        raise ReleaseError("CHANGELOG.md has no released versions")
    return versions[0]


def split_changelog_link_block(changelog: str) -> tuple[str, str]:
    match = re.search(r"\n\[unreleased\]: .*\Z", changelog, re.S | re.I)
    if not match:
        raise ReleaseError("CHANGELOG.md has no [unreleased] link block")
    return changelog[: match.start()].rstrip() + "\n", changelog[match.start() + 1 :]


def rebuild_changelog_links(
    changelog_body: str,
    *,
    unreleased_base: str,
    previous_for_oldest: str | None = None,
) -> str:
    versions = release_versions_from_headings(changelog_body)
    if not versions:
        raise ReleaseError("Cannot rebuild changelog links without release headings")

    lines = [
        f"[unreleased]: {REPO_URL}/compare/{versions[0].tag}...{unreleased_base}"
    ]
    for idx, current in enumerate(versions):
        if idx + 1 < len(versions):
            previous = versions[idx + 1].tag
            lines.append(
                f"[{current.text}]: {REPO_URL}/compare/{previous}...{current.tag}"
            )
        elif previous_for_oldest:
            lines.append(
                f"[{current.text}]: {REPO_URL}/compare/{previous_for_oldest}...{current.tag}"
            )
        else:
            lines.append(f"[{current.text}]: {REPO_URL}/releases/tag/{current.tag}")
    return changelog_body.rstrip() + "\n\n" + "\n".join(lines) + "\n"


def close_unreleased_section(
    changelog: str,
    *,
    version: Version,
    release_date: str,
    unreleased_base: str,
) -> tuple[str, str, Version]:
    body, _link_block = split_changelog_link_block(changelog)
    if f"## [{version.text}]" in body:
        raise ReleaseError(f"CHANGELOG.md already contains section {version.text}")

    headings = find_headings(body)
    if not headings or headings[0][0] != "Unreleased":
        raise ReleaseError("CHANGELOG.md must start its entries with ## [Unreleased]")
    if len(headings) < 2:
        raise ReleaseError("CHANGELOG.md needs a previous release section")

    previous_version = parse_version(headings[1][0])
    unreleased_start = headings[0][1]
    next_heading_start = headings[1][1]

    header_match = re.match(
        r"## \[Unreleased\]\n", body[unreleased_start:], flags=re.M
    )
    if not header_match:
        raise ReleaseError("Could not parse ## [Unreleased] header")

    prefix = body[:unreleased_start]
    unreleased_content = body[
        unreleased_start + len(header_match.group(0)) : next_heading_start
    ].strip()
    suffix = body[next_heading_start:].lstrip("\n")

    if not unreleased_content:
        raise ReleaseError("Unreleased section is empty; nothing to release")

    new_body = (
        prefix
        + "## [Unreleased]\n\n"
        + f"## [{version.text}] - {release_date}\n\n"
        + unreleased_content
        + "\n\n"
        + suffix
    )
    new_changelog = rebuild_changelog_links(
        new_body,
        unreleased_base=unreleased_base,
    )
    return new_changelog, unreleased_content, previous_version


def extract_release_section(changelog: str, version: Version) -> str:
    body, _link_block = split_changelog_link_block(changelog)
    pattern = re.compile(
        rf"^## \[{re.escape(version.text)}\] - .*$", re.M
    )
    match = pattern.search(body)
    if not match:
        raise ReleaseError(f"Could not find CHANGELOG.md section for {version.text}")
    next_match = re.search(r"^## \[", body[match.end() :], re.M)
    end = match.end() + next_match.start() if next_match else len(body)
    section = body[match.end() : end].strip()
    if not section:
        raise ReleaseError(f"CHANGELOG.md section for {version.text} is empty")
    return section


def release_notes(changelog: str, version: Version, previous: Version) -> str:
    section = extract_release_section(changelog, version)
    return (
        "## \U0001f53d Read the summarized changelog here \U0001f53d\n\n"
        f"{section}\n\n"
        f"**Full Changelog**: {REPO_URL}/compare/{previous.tag}...{version.tag}\n\n"
        "### \U0001f4c3 Check the official documentation here: "
        f"[\u26d3\ufe0f\u200d\U0001f4a5 Giswater Documentation ]({DOCS_URL})\n"
    )


def update_metadata_version(metadata: str, version: Version) -> str:
    lines = metadata.splitlines()
    out: list[str] = []
    idx = 0
    saw_version = False
    saw_changelog = False

    while idx < len(lines):
        line = lines[idx]
        if line.startswith("version="):
            out.append(f"version={version.text}")
            saw_version = True
            idx += 1
            continue
        if line.startswith("Changelog="):
            out.append(f"Changelog=Version {version.text}")
            saw_changelog = True
            idx += 1
            while idx < len(lines) and (
                lines[idx].startswith((" ", "\t")) or lines[idx] == ""
            ):
                idx += 1
            out.append("")
            continue
        out.append(line)
        idx += 1

    if not saw_version:
        raise ReleaseError("metadata.txt has no version= line")
    if not saw_changelog:
        raise ReleaseError("metadata.txt has no Changelog= line")
    return "\n".join(out).rstrip() + "\n"


def metadata_version(metadata: str) -> Version:
    match = re.search(r"^version=(\d+\.\d+\.\d+)$", metadata, re.M)
    if not match:
        raise ReleaseError("metadata.txt has no valid version=X.Y.Z line")
    return parse_version(match.group(1))


def print_file_plan(changes: list[PlannedChange], root: Path) -> None:
    for change in changes:
        if not change.changed:
            print(f"No changes for {change.path.relative_to(root)}")
            continue
        print(unified_diff(change, root))


def stage_and_commit(
    root: Path,
    *,
    execute: bool,
    paths: list[Path],
    message: str,
) -> None:
    rel_paths = [str(path.relative_to(root)) for path in paths]
    git(root, "add", *rel_paths, execute=execute)
    git(root, "commit", "-m", message, execute=execute)


def ensure_tag_available(root: Path, tag: str, *, resume: bool) -> None:
    if ref_exists(root, f"refs/tags/{tag}") and not resume:
        raise ReleaseError(f"Tag {tag} already exists. Use --resume to continue.")


def ensure_branch_available(
    root: Path, remote: str, branch: str, *, resume: bool
) -> None:
    if local_or_remote_branch_exists(root, remote, branch) and not resume:
        raise ReleaseError(f"Branch {branch} already exists. Use --resume to continue.")


def create_tag(
    root: Path,
    *,
    tag: str,
    execute: bool,
    resume: bool,
) -> None:
    if ref_exists(root, f"refs/tags/{tag}"):
        if resume:
            print(f"Tag {tag} already exists; --resume keeps it")
            return
        raise ReleaseError(f"Tag {tag} already exists")
    git(root, "tag", "-a", tag, "-m", f"Release {tag}", execute=execute)


def create_or_switch_branch(
    root: Path,
    *,
    remote: str,
    branch: str,
    start_point: str,
    execute: bool,
    resume: bool,
) -> None:
    if resume and ref_exists(root, f"refs/heads/{branch}"):
        git(root, "switch", branch, execute=execute)
        return
    if resume and ref_exists(root, f"refs/remotes/{remote}/{branch}"):
        git(root, "switch", "--track", f"{remote}/{branch}", execute=execute)
        return
    git(root, "switch", "-c", branch, start_point, execute=execute)


def create_github_release(
    root: Path,
    *,
    version: Version,
    notes: str,
    execute: bool,
) -> None:
    if not execute:
        print("--- GitHub release notes ---")
        print(notes.rstrip())
        print("--- End GitHub release notes ---")
        if shutil.which("gh"):
            run(
                [
                    "gh",
                    "release",
                    "create",
                    version.tag,
                    "--title",
                    version.tag,
                    "--notes-file",
                    "/tmp/release-notes.md",
                ],
                cwd=root,
                execute=False,
            )
        else:
            print(
                "$ POST https://api.github.com/repos/"
                f"{GH_REPO}/releases "
                f"(tag_name={version.tag}, name={version.tag})"
            )
        return

    if shutil.which("gh") is None:
        create_github_release_with_api(version, notes)
        return

    with tempfile.NamedTemporaryFile("w", encoding="utf-8", delete=False) as handle:
        handle.write(notes)
        notes_file = handle.name
    try:
        run(
            [
                "gh",
                "release",
                "create",
                version.tag,
                "--title",
                version.tag,
                "--notes-file",
                notes_file,
            ],
            cwd=root,
            execute=True,
        )
    finally:
        Path(notes_file).unlink(missing_ok=True)


def create_github_release_with_api(version: Version, notes: str) -> None:
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        raise ReleaseError(
            "gh is not installed. Install gh or export GITHUB_TOKEN to create "
            "the GitHub Release via API."
        )

    payload = {
        "tag_name": version.tag,
        "name": version.tag,
        "body": notes,
        "draft": False,
        "prerelease": False,
    }
    request = urllib.request.Request(
        f"https://api.github.com/repos/{GH_REPO}/releases",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "X-GitHub-Api-Version": "2022-11-28",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request) as response:
            release = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        message = exc.read().decode("utf-8", errors="replace")
        raise ReleaseError(f"GitHub release API failed: {exc.code}\n{message}") from exc

    print(f"Created GitHub Release: {release.get('html_url', version.tag)}")


def prepare_minor_release(args: argparse.Namespace, root: Path, version: Version) -> None:
    execute = args.execute
    ensure_expected_branch(root, "main", execute=execute)
    if execute:
        ensure_clean(root, execute=True)
    else:
        ensure_clean(root, execute=False)

    changelog_path = root / "CHANGELOG.md"
    metadata_path = root / "metadata.txt"
    changelog = read_text(changelog_path)
    metadata = read_text(metadata_path)

    if metadata_version(metadata) != version:
        raise ReleaseError(
            f"metadata.txt version must be {version.text} before release"
        )

    next_main = version.next_minor
    next_patch = version.next_patch

    new_changelog, _released_body, previous = close_unreleased_section(
        changelog,
        version=version,
        release_date=args.date,
        unreleased_base="main",
    )
    release_body = release_notes(new_changelog, version, previous)

    release_change = PlannedChange(changelog_path, changelog, new_changelog)
    main_metadata_change = PlannedChange(
        metadata_path,
        metadata,
        update_metadata_version(metadata, next_main),
    )
    release_metadata_change = PlannedChange(
        metadata_path,
        metadata,
        update_metadata_version(metadata, next_patch),
    )

    print("== Release changelog commit ==")
    print_file_plan([release_change], root)
    print("== Main next-version metadata ==")
    print_file_plan([main_metadata_change], root)
    print("== Release branch next-version metadata ==")
    print_file_plan([release_metadata_change], root)

    if not execute:
        print_minor_commands(args, root, version)
        if args.create_github_release:
            create_github_release(root, version=version, notes=release_body, execute=False)
        return

    git(root, "fetch", args.remote, "--tags", execute=True)
    git(root / "libs", "fetch", args.remote, "--tags", execute=True)
    ensure_tag_available(root, version.tag, resume=args.resume)
    if not args.skip_libs_tag:
        ensure_tag_available(root / "libs", version.tag, resume=args.resume)
    ensure_branch_available(
        root, args.remote, version.release_branch, resume=args.resume
    )

    write_change(release_change)
    stage_and_commit(
        root,
        execute=True,
        paths=[changelog_path],
        message=f"chore(release): prepare {version.text}",
    )

    if not args.skip_libs_tag:
        create_tag(root / "libs", tag=version.tag, execute=True, resume=args.resume)
        git(root / "libs", "push", args.remote, version.tag, execute=True)

    create_tag(root, tag=version.tag, execute=True, resume=args.resume)
    git(root, "push", args.remote, "main", version.tag, execute=True)

    create_or_switch_branch(
        root,
        remote=args.remote,
        branch=version.release_branch,
        start_point=version.tag,
        execute=True,
        resume=args.resume,
    )
    git(root, "push", "-u", args.remote, version.release_branch, execute=True)

    git(root, "switch", "main", execute=True)
    write_change(main_metadata_change)
    stage_and_commit(
        root,
        execute=True,
        paths=[metadata_path],
        message=f"chore: start {next_main.text} development",
    )
    git(root, "push", args.remote, "main", execute=True)

    git(root, "switch", version.release_branch, execute=True)
    write_change(release_metadata_change)
    stage_and_commit(
        root,
        execute=True,
        paths=[metadata_path],
        message=f"chore: start {next_patch.text} development",
    )
    git(root, "push", args.remote, version.release_branch, execute=True)

    if args.create_github_release:
        create_github_release(root, version=version, notes=release_body, execute=True)


def print_minor_commands(args: argparse.Namespace, root: Path, version: Version) -> None:
    del root
    next_main = version.next_minor
    next_patch = version.next_patch
    print("== Commands dry-run ==")
    git(repo_root(), "fetch", args.remote, "--tags", execute=False)
    git(repo_root() / "libs", "fetch", args.remote, "--tags", execute=False)
    git(repo_root(), "add", "CHANGELOG.md", execute=False)
    git(
        repo_root(),
        "commit",
        "-m",
        f"chore(release): prepare {version.text}",
        execute=False,
    )
    if not args.skip_libs_tag:
        git(
            repo_root() / "libs",
            "tag",
            "-a",
            version.tag,
            "-m",
            f"Release {version.tag}",
            execute=False,
        )
        git(repo_root() / "libs", "push", args.remote, version.tag, execute=False)
    git(
        repo_root(),
        "tag",
        "-a",
        version.tag,
        "-m",
        f"Release {version.tag}",
        execute=False,
    )
    git(repo_root(), "push", args.remote, "main", version.tag, execute=False)
    git(
        repo_root(),
        "switch",
        "-c",
        version.release_branch,
        version.tag,
        execute=False,
    )
    git(repo_root(), "push", "-u", args.remote, version.release_branch, execute=False)
    git(repo_root(), "switch", "main", execute=False)
    git(repo_root(), "add", "metadata.txt", execute=False)
    git(
        repo_root(),
        "commit",
        "-m",
        f"chore: start {next_main.text} development",
        execute=False,
    )
    git(repo_root(), "push", args.remote, "main", execute=False)
    git(repo_root(), "switch", version.release_branch, execute=False)
    git(repo_root(), "add", "metadata.txt", execute=False)
    git(
        repo_root(),
        "commit",
        "-m",
        f"chore: start {next_patch.text} development",
        execute=False,
    )
    git(repo_root(), "push", args.remote, version.release_branch, execute=False)


def prepare_patch_release(args: argparse.Namespace, root: Path, version: Version) -> None:
    execute = args.execute
    ensure_expected_branch(root, version.release_branch, execute=execute)
    ensure_clean(root, execute=execute)

    changelog_path = root / "CHANGELOG.md"
    metadata_path = root / "metadata.txt"
    changelog = read_text(changelog_path)
    metadata = read_text(metadata_path)

    if metadata_version(metadata) != version:
        raise ReleaseError(
            f"metadata.txt version must be {version.text} before release"
        )

    new_changelog, _released_body, previous = close_unreleased_section(
        changelog,
        version=version,
        release_date=args.date,
        unreleased_base=version.release_branch,
    )
    release_body = release_notes(new_changelog, version, previous)
    next_patch = version.next_patch

    release_change = PlannedChange(changelog_path, changelog, new_changelog)
    next_metadata_change = PlannedChange(
        metadata_path,
        metadata,
        update_metadata_version(metadata, next_patch),
    )

    print("== Release changelog commit ==")
    print_file_plan([release_change], root)
    print("== Release branch next-version metadata ==")
    print_file_plan([next_metadata_change], root)

    if not execute:
        print_patch_commands(args, version)
        if args.create_github_release:
            create_github_release(root, version=version, notes=release_body, execute=False)
        return

    git(root, "fetch", args.remote, "--tags", execute=True)
    git(root / "libs", "fetch", args.remote, "--tags", execute=True)
    ensure_tag_available(root, version.tag, resume=args.resume)
    if not args.skip_libs_tag:
        ensure_tag_available(root / "libs", version.tag, resume=args.resume)

    write_change(release_change)
    stage_and_commit(
        root,
        execute=True,
        paths=[changelog_path],
        message=f"chore(release): prepare {version.text}",
    )

    if not args.skip_libs_tag:
        create_tag(root / "libs", tag=version.tag, execute=True, resume=args.resume)
        git(root / "libs", "push", args.remote, version.tag, execute=True)

    create_tag(root, tag=version.tag, execute=True, resume=args.resume)
    git(root, "push", args.remote, version.release_branch, version.tag, execute=True)

    write_change(next_metadata_change)
    stage_and_commit(
        root,
        execute=True,
        paths=[metadata_path],
        message=f"chore: start {next_patch.text} development",
    )
    git(root, "push", args.remote, version.release_branch, execute=True)

    if args.create_github_release:
        create_github_release(root, version=version, notes=release_body, execute=True)


def print_patch_commands(args: argparse.Namespace, version: Version) -> None:
    print("== Commands dry-run ==")
    git(repo_root(), "fetch", args.remote, "--tags", execute=False)
    git(repo_root() / "libs", "fetch", args.remote, "--tags", execute=False)
    git(repo_root(), "add", "CHANGELOG.md", execute=False)
    git(
        repo_root(),
        "commit",
        "-m",
        f"chore(release): prepare {version.text}",
        execute=False,
    )
    if not args.skip_libs_tag:
        git(
            repo_root() / "libs",
            "tag",
            "-a",
            version.tag,
            "-m",
            f"Release {version.tag}",
            execute=False,
        )
        git(repo_root() / "libs", "push", args.remote, version.tag, execute=False)
    git(
        repo_root(),
        "tag",
        "-a",
        version.tag,
        "-m",
        f"Release {version.tag}",
        execute=False,
    )
    git(repo_root(), "push", args.remote, version.release_branch, version.tag, execute=False)
    git(repo_root(), "add", "metadata.txt", execute=False)
    git(
        repo_root(),
        "commit",
        "-m",
        f"chore: start {version.next_patch.text} development",
        execute=False,
    )
    git(repo_root(), "push", args.remote, version.release_branch, execute=False)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Prepare Giswater release")
    parser.add_argument("version", help="Release version, e.g. 4.9.0 or 4.9.1")
    parser.add_argument(
        "--execute",
        action="store_true",
        help="Apply file changes and run git commands. Default is dry-run.",
    )
    parser.add_argument(
        "--create-github-release",
        action="store_true",
        help="Create a published GitHub Release using gh.",
    )
    parser.add_argument(
        "--skip-libs-tag",
        action="store_true",
        help="Do not create/push the matching tag in libs.",
    )
    parser.add_argument(
        "--resume",
        action="store_true",
        help="Continue if expected tags already exist.",
    )
    parser.add_argument(
        "--date",
        default=date.today().isoformat(),
        help="Release date for CHANGELOG.md. Default: today.",
    )
    parser.add_argument(
        "--remote",
        default="origin",
        help="Git remote to push to. Default: origin.",
    )
    return parser


def main() -> int:
    args = build_parser().parse_args()
    root = repo_root()
    try:
        version = parse_version(args.version)
        if version.is_minor_release:
            prepare_minor_release(args, root, version)
        else:
            prepare_patch_release(args, root, version)
    except ReleaseError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
