"""``dbmodel`` subcommands: install, list, use, status."""

from __future__ import annotations

import argparse
import os

from ..install import releases
from ..install.config import (
    cache_dir,
    config_file,
    download_settings,
    list_cached_versions,
    load_config,
    release_dbmodel_dir,
    save_config,
)
from ..install.dbmodel_paths import resolve_dbmodel_path
from ..output import Out


def run_list(args: argparse.Namespace, out: Out) -> int:
    cached = list_cached_versions()
    cfg = load_config()
    active_path: str | None = None
    try:
        active_path = resolve_dbmodel_path(None)
    except RuntimeError:
        pass

    remote_latest: str | None = None
    remote_error: str | None = None
    if not args.offline:
        base_url, major = download_settings(cfg)
        try:
            remote_latest = releases.fetch_latest_version(base_url, major=major)
        except RuntimeError as e:
            remote_error = str(e)

    payload = {
        "ok": True,
        "cache_dir": str(cache_dir()),
        "cached": cached,
        "active_path": active_path,
        "config": cfg.get("dbmodel"),
        "remote_latest": remote_latest,
        "remote_error": remote_error,
    }
    if args.json:
        out.result(payload)
        return 0

    out.info(f"Cache: {cache_dir()}")
    if cached:
        out.info("Cached versions:")
        for version in cached:
            marker = " (active)" if active_path and version in active_path else ""
            out.info(f"  {version}{marker}")
    else:
        out.info("No cached releases.")
    if remote_latest:
        _, major = download_settings(cfg)
        out.info(f"Remote latest (major {major}): {remote_latest}")
    elif remote_error:
        out.info(f"Remote latest: unavailable ({remote_error})")
    if active_path:
        out.info(f"Active dbmodel: {active_path}")
    return 0


def run_install(args: argparse.Namespace, out: Out) -> int:
    cfg = load_config()
    base_url, major = download_settings(cfg)

    if args.version == "latest":
        version, path = releases.install_latest(
            base_url=base_url,
            major=major,
            force=args.force,
        )
    else:
        version = args.version
        path = releases.install_release(
            version,
            base_url=base_url,
            force=args.force,
        )

    if args.set_active:
        dbmodel = cfg.setdefault("dbmodel", {})
        dbmodel["source"] = "release"
        dbmodel["version"] = version
        dbmodel["dev_root"] = None
        save_config(cfg)

    payload = {
        "ok": True,
        "version": version,
        "path": str(path),
        "set_active": bool(args.set_active),
    }
    if args.json:
        out.result(payload)
    else:
        out.info(f"Installed dbmodel {version} -> {path}")
        if args.set_active:
            out.info("Set as active dbmodel source.")
    return 0


def run_use(args: argparse.Namespace, out: Out) -> int:
    cfg = load_config()
    dbmodel = cfg.setdefault("dbmodel", {})

    if args.mode == "dev":
        if not args.root:
            raise RuntimeError("--root is required when mode=dev")
        root = os.path.abspath(args.root)
        dbmodel_path = os.path.join(root, "dbmodel")
        if not os.path.isfile(os.path.join(dbmodel_path, "manifests", "ws.yaml")):
            raise RuntimeError(
                f"Invalid dev root (missing dbmodel/manifests/ws.yaml): {root}"
            )
        dbmodel["source"] = "dev"
        dbmodel["dev_root"] = root
        dbmodel["version"] = None
        save_config(cfg)
        payload = {"ok": True, "source": "dev", "dev_root": root, "path": dbmodel_path}
        if args.json:
            out.result(payload)
        else:
            out.info(f"Using dev dbmodel from {dbmodel_path}")
        return 0

    base_url, major = download_settings(cfg)

    if args.mode == "latest":
        version = releases.fetch_latest_version(base_url, major=major)
    else:
        version = args.mode
        if releases.parse_version(version) is None:
            raise RuntimeError(f"Invalid version {version!r}; expected X.Y.Z or latest")

    path = release_dbmodel_dir(version)
    if not os.path.isfile(os.path.join(path, "manifests", "ws.yaml")):
        raise RuntimeError(
            f"dbmodel {version} is not installed. Run: gw dbmodel install {version}"
        )

    dbmodel["source"] = "release"
    dbmodel["version"] = version
    dbmodel["dev_root"] = None
    save_config(cfg)
    payload = {"ok": True, "source": "release", "version": version, "path": str(path)}
    if args.json:
        out.result(payload)
    else:
        out.info(f"Using release dbmodel {version} -> {path}")
    return 0


def run_status(args: argparse.Namespace, out: Out) -> int:
    cfg = load_config()
    payload = {
        "ok": True,
        "config_file": str(config_file()),
        "dbmodel": cfg.get("dbmodel"),
        "download": cfg.get("download"),
    }
    if args.json:
        out.result(payload)
        return 0
    out.info(f"Config: {config_file()}")
    for section in ("dbmodel", "download"):
        out.info(f"{section}:")
        section_data = cfg.get(section) or {}
        for key, value in section_data.items():
            out.info(f"  {key}: {value}")
    return 0
