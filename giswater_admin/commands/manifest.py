"""``manifest`` sub-subcommands: ``manifest validate``, ``manifest list``."""

from __future__ import annotations

import argparse
import os

from ..engine import load_manifest
from ..engine.manifest import ManifestError
from ..output import Out


def validate(args: argparse.Namespace, out: Out) -> int:
    try:
        m = load_manifest(args.path)
    except ManifestError as e:
        out.error(str(e))
        out.result({"ok": False, "error": str(e), "path": args.path})
        return 1
    out.result(
        {
            "ok": True,
            "path": args.path,
            "kind": m.kind,
            "engine_version": m.engine_version,
            "phases": [p.id for p in m.phases],
            "profiles": sorted(m.profiles.keys()),
        }
    )
    return 0


def list_kinds(args: argparse.Namespace, out: Out) -> int:
    root = os.path.join(args.dbmodel_path, "manifests")
    if not os.path.isdir(root):
        out.error(f"manifests folder not found: {root}")
        return 1
    items = []
    for fn in sorted(os.listdir(root)):
        if not fn.endswith(".yaml"):
            continue
        path = os.path.join(root, fn)
        try:
            m = load_manifest(path)
            items.append(
                {
                    "kind": m.kind,
                    "path": path,
                    "profiles": sorted(m.profiles.keys()),
                    "phases": len(m.phases),
                }
            )
        except ManifestError as e:
            items.append({"kind": fn, "path": path, "error": str(e)})
    out.result({"ok": True, "manifests": items})
    return 0
