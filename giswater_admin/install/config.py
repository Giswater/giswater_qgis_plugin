"""Persistent user configuration for the ``gw`` CLI."""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any

import platformdirs

try:
    import yaml
except ImportError as e:  # pragma: no cover
    raise RuntimeError("PyYAML is required by giswater_admin") from e

DEFAULT_BASE_URL = "https://download.giswater.org/plugin"
DEFAULT_MAJOR = 4

_DEFAULTS: dict[str, Any] = {
    "dbmodel": {
        "source": "release",
        "version": None,
        "dev_root": None,
    },
    "database": {
        "conn": None,
        "config": None,
    },
    "download": {
        "base_url": DEFAULT_BASE_URL,
        "major": DEFAULT_MAJOR,
    },
}


def config_dir() -> Path:
    return Path(platformdirs.user_config_dir("giswater", appauthor=False))


def config_file() -> Path:
    return config_dir() / "config.yaml"


def cache_dir() -> Path:
    return Path(platformdirs.user_data_dir("giswater", appauthor=False)) / "releases"


def load_config() -> dict[str, Any]:
    path = config_file()
    if not path.is_file():
        return _deep_copy(_DEFAULTS)
    with path.open("r", encoding="utf-8") as fh:
        body = yaml.safe_load(fh) or {}
    if not isinstance(body, dict):
        return _deep_copy(_DEFAULTS)
    merged = _deep_copy(_DEFAULTS)
    _deep_merge(merged, body)
    return merged


def save_config(data: dict[str, Any]) -> Path:
    path = config_file()
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        yaml.safe_dump(data, fh, default_flow_style=False, sort_keys=False)
    return path


def set_config_value(key_path: str, value: Any) -> dict[str, Any]:
    cfg = load_config()
    parts = key_path.split(".")
    node = cfg
    for part in parts[:-1]:
        child = node.get(part)
        if not isinstance(child, dict):
            child = {}
            node[part] = child
        node = child
    node[parts[-1]] = value
    save_config(cfg)
    return cfg


def get_config_value(key_path: str) -> Any:
    cfg = load_config()
    node: Any = cfg
    for part in key_path.split("."):
        if not isinstance(node, dict) or part not in node:
            return None
        node = node[part]
    return node


def release_dbmodel_dir(version: str) -> Path:
    return cache_dir() / version / "dbmodel"


def list_cached_versions() -> list[str]:
    root = cache_dir()
    if not root.is_dir():
        return []
    out: list[str] = []
    for entry in root.iterdir():
        dbmodel = entry / "dbmodel"
        if entry.is_dir() and dbmodel.is_dir():
            out.append(entry.name)
    return sorted(out, key=_version_key)


def download_settings(cfg: dict[str, Any] | None = None) -> tuple[str, int]:
    """Return ``(base_url, major)`` from config."""
    data = cfg if cfg is not None else load_config()
    download = data.get("download") or {}
    base_url = download.get("base_url") or DEFAULT_BASE_URL
    major = int(download.get("major") or DEFAULT_MAJOR)
    return str(base_url), major


def _deep_copy(value: Any) -> Any:
    if isinstance(value, dict):
        return {k: _deep_copy(v) for k, v in value.items()}
    return value


def _deep_merge(base: dict[str, Any], overlay: dict[str, Any]) -> None:
    for key, value in overlay.items():
        if isinstance(value, dict) and isinstance(base.get(key), dict):
            _deep_merge(base[key], value)
        else:
            base[key] = value


def _version_key(version: str) -> tuple[int, ...]:
    parts: list[int] = []
    for piece in version.split("."):
        try:
            parts.append(int(piece))
        except ValueError:
            parts.append(0)
    return tuple(parts)


def read_metadata_version(root: str | os.PathLike[str]) -> str | None:
    """Return ``version=`` from ``metadata.txt`` under a plugin or repo root."""
    path = Path(root) / "metadata.txt"
    if not path.is_file():
        return None
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("version="):
            return line.split("=", 1)[1].strip() or None
    return None
