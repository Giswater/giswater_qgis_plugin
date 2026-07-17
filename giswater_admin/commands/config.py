"""``config`` subcommands: get, set."""

from __future__ import annotations

import argparse
import json

from ..install.config import config_file, get_config_value, load_config, set_config_value
from ..output import Out


def run_get(args: argparse.Namespace, out: Out) -> int:
    if args.key:
        value = get_config_value(args.key)
        payload = {"ok": True, "key": args.key, "value": value}
    else:
        payload = {"ok": True, "config_file": str(config_file()), "config": load_config()}
    if args.json:
        out.result(payload)
        return 0
    if args.key:
        if value is None:
            out.info(f"{args.key}: (not set)")
        else:
            out.info(f"{args.key}: {value}")
        return 0
    out.info(f"Config: {config_file()}")
    out.info(json.dumps(payload["config"], indent=2, sort_keys=True))
    return 0


def run_set(args: argparse.Namespace, out: Out) -> int:
    raw = args.value
    if raw.lower() in ("null", "none", "~"):
        value = None
    elif raw.lower() in ("true", "false"):
        value = raw.lower() == "true"
    else:
        try:
            value = json.loads(raw)
        except json.JSONDecodeError:
            value = raw
    cfg = set_config_value(args.key, value)
    payload = {"ok": True, "key": args.key, "value": value, "config": cfg}
    if args.json:
        out.result(payload)
    else:
        out.info(f"Set {args.key} = {value!r}")
    return 0
