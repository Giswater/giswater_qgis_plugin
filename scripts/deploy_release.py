#!/usr/bin/env python3
"""Deploy a QGIS plugin release to an SFTP server with versioned XML pointers.

Generates three giswater.xml files (patch, minor, major) and uploads them
along with the ZIP to the correct version-path structure on the server.
Pointer XMLs never downgrade: they always point to the highest published
version in their scope.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import stat
import sys
import tempfile
import urllib.request
from pathlib import Path
from typing import Protocol

import paramiko

# ---------------------------------------------------------------------------
# Version helpers
# ---------------------------------------------------------------------------


def parse_version(tag: str) -> tuple[int, int, int] | None:
    """Return (major, minor, patch) from a tag like '4.8.1' or 'v4.8.1'."""
    m = re.match(r"^v?(\d+)\.(\d+)\.(\d+)$", tag)
    if m:
        return int(m.group(1)), int(m.group(2)), int(m.group(3))
    return None


def fetch_published_versions(gh_repo: str, gh_token: str) -> list[tuple[int, int, int]]:
    """Fetch all published (non-draft, non-prerelease) versions via GitHub API."""
    versions: list[tuple[int, int, int]] = []
    page = 1
    while True:
        url = (
            f"https://api.github.com/repos/{gh_repo}/releases?per_page=100&page={page}"
        )
        req = urllib.request.Request(
            url,
            headers={
                "Accept": "application/vnd.github+json",
                "Authorization": f"Bearer {gh_token}",
                "X-GitHub-Api-Version": "2022-11-28",
            },
        )
        with urllib.request.urlopen(req) as resp:
            releases = json.loads(resp.read().decode())
        if not releases:
            break
        for rel in releases:
            if rel.get("draft") or rel.get("prerelease"):
                continue
            v = parse_version(rel.get("tag_name", ""))
            if v:
                versions.append(v)
        page += 1
    return versions


def compute_pointers(
    current: tuple[int, int, int],
    all_versions: list[tuple[int, int, int]],
) -> dict[str, tuple[int, int, int]]:
    """Compute which version each pointer XML should reference.

    Returns a dict with keys 'patch', 'minor', 'major' mapping to the version
    tuple each pointer should advertise.
    """
    major, minor, _ = current

    same_minor = [v for v in all_versions if v[0] == major and v[1] == minor]
    same_major = [v for v in all_versions if v[0] == major]

    return {
        "patch": current,
        "minor": max(same_minor),
        "major": max(same_major),
    }


# ---------------------------------------------------------------------------
# XML generation
# ---------------------------------------------------------------------------


def render_xml(template: str, version: tuple[int, int, int], base_url: str) -> str:
    ver_str = f"{version[0]}.{version[1]}.{version[2]}"
    download_url = f"{base_url}/{version[0]}/{version[1]}/{version[2]}/giswater.zip"
    xml = template.replace("__VERSION__", ver_str)
    xml = xml.replace("__DOWNLOAD_URL__", download_url)
    return xml


# ---------------------------------------------------------------------------
# SFTP transport (abstracted for testability)
# ---------------------------------------------------------------------------


class Uploader(Protocol):
    def mkdir_p(self, remote_dir: str) -> None: ...
    def put(self, local_path: str, remote_path: str) -> None: ...
    def close(self) -> None: ...


class SFTPUploader:
    def __init__(self, host: str, user: str, password: str, port: int = 22):
        transport = paramiko.Transport((host, port))
        transport.connect(username=user, password=password)
        self.sftp = paramiko.SFTPClient.from_transport(transport)
        self._transport = transport

    def mkdir_p(self, remote_dir: str) -> None:
        dirs_to_create: list[str] = []
        current = remote_dir
        while True:
            try:
                self.sftp.stat(current)
                break
            except FileNotFoundError:
                dirs_to_create.append(current)
                parent = os.path.dirname(current)
                if parent == current:
                    break
                current = parent
        for d in reversed(dirs_to_create):
            self.sftp.mkdir(d)

    def put(self, local_path: str, remote_path: str) -> None:
        self.sftp.put(local_path, remote_path)

    def close(self) -> None:
        self.sftp.close()
        self._transport.close()


class LocalUploader:
    """Drop-in replacement that writes to a local directory (for testing)."""

    def __init__(self, base_dir: str):
        self.base_dir = base_dir

    def mkdir_p(self, remote_dir: str) -> None:
        Path(self.base_dir, remote_dir.lstrip("/")).mkdir(parents=True, exist_ok=True)

    def put(self, local_path: str, remote_path: str) -> None:
        dest = Path(self.base_dir, remote_path.lstrip("/"))
        dest.parent.mkdir(parents=True, exist_ok=True)
        import shutil

        shutil.copy2(local_path, dest)

    def close(self) -> None:
        pass


# ---------------------------------------------------------------------------
# Deploy logic
# ---------------------------------------------------------------------------


def deploy(
    version_str: str,
    zip_path: str,
    template_path: str,
    base_url: str,
    sftp_base: str,
    all_versions: list[tuple[int, int, int]],
    uploader: Uploader,
) -> None:
    current = parse_version(version_str)
    if current is None:
        print(f"ERROR: '{version_str}' is not a valid X.Y.Z version", file=sys.stderr)
        sys.exit(1)

    # Defensively add current version
    if current not in all_versions:
        all_versions.append(current)

    pointers = compute_pointers(current, all_versions)
    template = Path(template_path).read_text(encoding="utf-8")
    major, minor, patch = current

    with tempfile.TemporaryDirectory() as tmp:
        # Generate XMLs
        xml_files: dict[str, str] = {}
        for key, ver in pointers.items():
            xml_content = render_xml(template, ver, base_url)
            xml_path = os.path.join(tmp, f"giswater_{key}.xml")
            Path(xml_path).write_text(xml_content, encoding="utf-8")
            xml_files[key] = xml_path

        # Build remote paths
        patch_dir = f"{sftp_base}/{major}/{minor}/{patch}"
        minor_dir = f"{sftp_base}/{major}/{minor}"
        major_dir = f"{sftp_base}/{major}"

        # Create directories and upload
        uploader.mkdir_p(patch_dir)

        print(f"Uploading ZIP to {patch_dir}/giswater.zip")
        uploader.put(zip_path, f"{patch_dir}/giswater.zip")

        print(f"Uploading patch XML to {patch_dir}/giswater.xml")
        uploader.put(xml_files["patch"], f"{patch_dir}/giswater.xml")

        print(f"Uploading minor XML to {minor_dir}/giswater.xml")
        uploader.put(xml_files["minor"], f"{minor_dir}/giswater.xml")

        print(f"Uploading major XML to {major_dir}/giswater.xml")
        uploader.put(xml_files["major"], f"{major_dir}/giswater.xml")

    uploader.close()
    print(f"Deploy of {version_str} complete.")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Deploy QGIS plugin release to SFTP server")
    p.add_argument("--version", required=True, help="Version to deploy (X.Y.Z)")
    p.add_argument("--zip", required=True, help="Path to the plugin ZIP file")
    p.add_argument("--template", required=True, help="Path to plugin_template.xml")
    p.add_argument("--gh-repo", required=True, help="GitHub repo (owner/name)")
    p.add_argument("--gh-token", required=True, help="GitHub token for API access")
    p.add_argument("--sftp-host", required=True, help="SFTP server hostname")
    p.add_argument("--sftp-user", required=True, help="SFTP username")
    p.add_argument("--sftp-password", required=True, help="SFTP password")
    p.add_argument("--sftp-base", required=True, help="Remote base path (e.g. /plugin)")
    p.add_argument("--sftp-port", type=int, default=22, help="SFTP port (default: 22)")
    p.add_argument(
        "--base-url",
        required=True,
        help="Public base URL (e.g. https://download.giswater.org/plugin)",
    )
    # Hidden flag for local testing
    p.add_argument("--local-dir", help=argparse.SUPPRESS)
    return p


def main() -> None:
    args = build_parser().parse_args()

    if args.local_dir:
        all_versions = _load_local_versions(args.local_dir, args.version)
        uploader: Uploader = LocalUploader(args.local_dir)
    else:
        print(f"Fetching published releases from {args.gh_repo}...")
        all_versions = fetch_published_versions(args.gh_repo, args.gh_token)
        print(f"Found {len(all_versions)} published release(s)")
        uploader = SFTPUploader(
            args.sftp_host, args.sftp_user, args.sftp_password, args.sftp_port
        )

    deploy(
        version_str=args.version,
        zip_path=args.zip,
        template_path=args.template,
        base_url=args.base_url,
        sftp_base=args.sftp_base,
        all_versions=all_versions,
        uploader=uploader,
    )


def _load_local_versions(
    local_dir: str, current_version: str
) -> list[tuple[int, int, int]]:
    """Load previously deployed versions from a manifest file in the local dir."""
    manifest = Path(local_dir) / ".versions"
    versions: list[tuple[int, int, int]] = []
    if manifest.exists():
        for line in manifest.read_text().splitlines():
            v = parse_version(line.strip())
            if v:
                versions.append(v)
    cur = parse_version(current_version)
    if cur and cur not in versions:
        versions.append(cur)
    # Persist updated manifest
    manifest.parent.mkdir(parents=True, exist_ok=True)
    manifest.write_text(
        "\n".join(f"{v[0]}.{v[1]}.{v[2]}" for v in sorted(set(versions))) + "\n"
    )
    return versions


if __name__ == "__main__":
    main()
