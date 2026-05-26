"""
Template rendering.

Two distinct substitution layers, both intentionally tiny:

- ``render(value, ctx)``: walks Python values (str/dict/list/tuple) and
  replaces ``{{ key }}`` tokens with ``str(ctx[key])``. Used at manifest
  load + path resolution time. No Jinja, no expressions — predictability
  beats power.

- ``apply_subs(text, subs)``: file-content substitution mirroring the
  legacy ``_read_execute_file`` behaviour, i.e. literal string replace
  of ``SCHEMA_NAME`` / ``SRID_VALUE`` / ``SCHEMA_SRID`` / ``AUX_SCHEMA_NAME`` and a few
  others. ``BD_NAME`` is replaced case-insensitively because legacy SQL
  uses both ``BD_NAME`` and ``bd_name``.
"""

from __future__ import annotations

import re
from typing import Any, Mapping

_TOKEN_RE = re.compile(r"\{\{\s*([A-Za-z_][A-Za-z0-9_]*)\s*\}\}")


def render(value: Any, ctx: Mapping[str, Any]) -> Any:
    """Recursively render ``{{ var }}`` placeholders in str/dict/list/tuple."""
    if isinstance(value, str):
        return _TOKEN_RE.sub(lambda m: str(ctx.get(m.group(1), m.group(0))), value)
    if isinstance(value, dict):
        return {k: render(v, ctx) for k, v in value.items()}
    if isinstance(value, list):
        return [render(v, ctx) for v in value]
    if isinstance(value, tuple):
        return tuple(render(v, ctx) for v in value)
    return value


_CI_REPLACERS = {"BD_NAME"}


def apply_subs(text: str, subs: Mapping[str, str]) -> str:
    """
    Literal-substring substitution over SQL file contents.

    Single-pass regex alternation, longest-key-first. This guarantees
    that ``SCHEMA_NAME`` (11 chars) never bites into ``AUX_SCHEMA_NAME``
    (15 chars) — including the case where ``AUX_SCHEMA_NAME``'s value
    is ``None`` and the key should be left verbatim. We include
    ``None``-valued keys in the alternation but the callback returns the
    original match for them, claiming the position so shorter keys
    cannot match the same characters again.

    Keys in :data:`_CI_REPLACERS` (currently just ``BD_NAME``) match
    case-insensitively, mirroring legacy ``_read_execute_cm_file``.
    """
    case_sensitive = [k for k in subs if k not in _CI_REPLACERS]
    case_insensitive = [k for k in subs if k in _CI_REPLACERS]

    out = text
    if case_sensitive:
        case_sensitive.sort(key=len, reverse=True)
        pattern = "|".join(re.escape(k) for k in case_sensitive)

        def _replace_cs(m: re.Match[str]) -> str:
            v = subs[m.group(0)]
            return m.group(0) if v is None else v

        out = re.sub(pattern, _replace_cs, out)

    if case_insensitive:
        case_insensitive.sort(key=len, reverse=True)
        pattern = "|".join(re.escape(k) for k in case_insensitive)

        def _replace_ci(m: re.Match[str]) -> str:
            for k in case_insensitive:
                if k.lower() == m.group(0).lower():
                    v = subs[k]
                    return m.group(0) if v is None else v
            return m.group(0)

        out = re.sub(pattern, _replace_ci, out, flags=re.IGNORECASE)
    return out
