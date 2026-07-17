"""
Shared formatting for schema-build progress logs (CLI stderr and QGIS Message Log).

Keeps path shortening, column alignment, phase banners, and timing rollups
consistent across ``Out``, ``build_progress_cb``, and ``GwSchemaBuilderTask``.
"""

from __future__ import annotations

import os
import sys
from dataclasses import dataclass
from typing import Any

# ANSI (CLI only when ``LogStyle.use_color`` and stderr is a TTY).
_RESET = "\033[0m"
_DIM = "\033[2m"
_CYAN = "\033[36m"
_YELLOW = "\033[33m"
_GREEN = "\033[32m"
_RED = "\033[31m"


@dataclass
class LogStyle:
    """Display options for schema-build log lines."""

    sql_root: str = ""
    slow_ms: int = 0  # 0 = log every file when caller emits file lines
    use_color: bool = False
    width_path: int = 56
    show_timing_ms: bool = False

    def color_enabled(self) -> bool:
        return bool(self.use_color) and sys.stderr.isatty()


def default_log_style(*, sql_root: str = "", timing: bool = False) -> LogStyle:
    """CLI-friendly defaults (color when stderr is a TTY)."""
    return LogStyle(
        sql_root=sql_root or "",
        use_color=sys.stderr.isatty(),
        show_timing_ms=bool(timing),
    )


def shorten_path(path: str, sql_root: str = "") -> str:
    """Strip ``sql_root`` and common ``dbmodel/`` prefixes for display."""
    if not path:
        return ""
    p = path.replace("\\", "/")
    root = (sql_root or "").replace("\\", "/").rstrip("/")
    if root and p.startswith(root + "/"):
        p = p[len(root) + 1:]
    elif root and p == root:
        p = ""
    for prefix in (
        "dbmodel/schemas/main/",
        "dbmodel/schemas/addon/",
        "dbmodel/schemas/network/",
        "dbmodel/schemas/",
        "schemas/main/",
        "schemas/addon/",
        "schemas/network/",
    ):
        if p.startswith(prefix):
            p = p[len(prefix):]
            break
    return p or os.path.basename(path.replace("\\", "/"))


def _counter(seen: int, total: int) -> str:
    width = max(3, len(str(total or 0)))
    return f"[{seen:>{width}}/{total}]"


def _maybe_color(text: str, code: str, style: LogStyle) -> str:
    if not style.color_enabled():
        return text
    return f"{code}{text}{_RESET}"


def format_build_header(
    kind: str,
    schema: str,
    profile: str,
    plugin_version: str,
    *,
    style: LogStyle | None = None,
) -> str:
    style = style or LogStyle()
    line = (
        f"── Schema build: {kind} / {schema}  "
        f"profile={profile}  v{plugin_version} ──"
    )
    return _maybe_color(line, _CYAN, style)


def format_phase(
    seen: int,
    total: int,
    phase_id: str,
    *,
    style: LogStyle | None = None,
) -> str:
    style = style or LogStyle()
    pid = phase_id.removeprefix("phase:") if phase_id.startswith("phase:") else phase_id
    line = f"{_counter(seen, total)}  phase  {pid}"
    return _maybe_color(line, _CYAN, style)


def format_done(seen: int, total: int, *, style: LogStyle | None = None) -> str:
    style = style or LogStyle()
    line = f"{_counter(seen, total)}  done"
    return _maybe_color(line, _GREEN, style)


def _format_duration_ms(ms: int | None) -> str:
    if ms is None or ms <= 0:
        return ""
    if ms >= 1000:
        return f"{ms / 1000:>6.1f}s"
    return f"{ms:>5}ms"


def format_file(
    seen: int,
    total: int,
    path: str,
    *,
    ms: int | None = None,
    style: LogStyle | None = None,
) -> str:
    style = style or LogStyle()
    short = shorten_path(path, style.sql_root)
    if len(short) > style.width_path:
        short = "…" + short[-(style.width_path - 1):]
    dur = ""
    if style.show_timing_ms or (ms is not None and ms > 0):
        dur = _format_duration_ms(ms)
    if dur:
        line = f"{_counter(seen, total)}  {dur}  {short}"
    else:
        line = f"{_counter(seen, total)}  {short}"
    if ms is not None and style.slow_ms and ms >= style.slow_ms:
        return _maybe_color(line, _YELLOW, style)
    return line


def format_elapsed_mmss(seconds: int) -> str:
    """Compact MM:SS elapsed time for QGIS ``lbl_time``."""
    seconds = max(0, int(seconds))
    return f"{seconds // 60:02d}:{seconds % 60:02d}"


def format_progress_status(
    seen: int,
    total: int,
    label: str,
    *,
    sql_root: str = "",
) -> str:
    """
    Compact status for QGIS ``lbl_time`` (counter + current file).
    """
    counter = f"[{seen}/{total}]" if total else ""
    if label == "done":
        return f"{counter} - done".strip(" -") if counter else "done"
    if label.startswith("phase:"):
        pid = label.removeprefix("phase:")
        return f"{counter} - phase {pid}".strip(" -") if counter else f"phase {pid}"
    if label.startswith("<fn:") or label.startswith("<inline:"):
        return counter
    file_part = shorten_path(label, sql_root)
    if counter and file_part:
        return f"{counter} - {file_part}"
    return counter or file_part


def format_lbl_time_status(
    elapsed_seconds: int,
    seen: int,
    total: int,
    label: str = "",
    *,
    sql_root: str = "",
) -> str:
    """``lbl_time`` line: ``MM:SS | [n/total] - file``."""
    elapsed = format_elapsed_mmss(elapsed_seconds)
    hint = format_progress_status(seen, total, label, sql_root=sql_root)
    if hint:
        return f"{elapsed} | {hint}"
    return elapsed


def format_timing_summary(
    summary: dict[str, Any],
    *,
    style: LogStyle | None = None,
    top_slowest: int = 15,
    top_updates: int = 15,
) -> list[str]:
    """Lines for the post-build timing rollup (no trailing newlines)."""
    style = style or LogStyle()
    lines: list[str] = []
    total_ms = int(summary.get("total_ms") or 0)
    file_count = int(summary.get("file_count") or 0)
    header = f"── Done  {total_ms / 1000:.1f}s  {file_count} files ──"
    lines.append(_maybe_color(header, _GREEN, style))

    for row in summary.get("by_phase", []):
        pct = row.get("pct", 0)
        phase_id = str(row.get("phase_id", ""))
        ms = int(row.get("ms") or 0)
        count = int(row.get("count") or 0)
        phase_col = phase_id.ljust(18)
        lines.append(
            f"  {phase_col} {ms / 1000:>6.1f}s  ({count} files, {pct}%)"
        )

    updates_by_version = summary.get("updates_by_version") or []
    if updates_by_version:
        lines.append("Updates by version:")
        for row in updates_by_version[:top_updates]:
            slow = row.get("slowest_file", "")
            if slow:
                slow = shorten_path(str(slow), style.sql_root)
                if "/" in slow:
                    slow = slow.rsplit("/", 1)[-1]
            lines.append(
                f"  {str(row.get('version', '')):>8}  {int(row.get('ms') or 0) / 1000:>6.1f}s  "
                f"({int(row.get('count') or 0)} files, {row.get('pct_of_updates', 0)}%)  "
                f"slowest={int(row.get('slowest_ms') or 0)}ms {slow}"
            )

    slowest = summary.get("slowest") or []
    if slowest:
        lines.append("Slowest:")
        for row in slowest[:top_slowest]:
            path = shorten_path(str(row.get("path", "")), style.sql_root)
            lines.append(
                f"  {int(row.get('duration_ms') or 0):>5}ms  "
                f"{str(row.get('phase_id', ''))}  {path}"
            )

    slowest_updates = (summary.get("slowest_by_phase") or {}).get("updates", [])
    if slowest_updates:
        lines.append("Slowest updates files:")
        for row in slowest_updates[:top_updates]:
            path = shorten_path(str(row.get("path", "")), style.sql_root)
            lines.append(
                f"  {int(row.get('duration_ms') or 0):>5}ms  {path}"
            )
    return lines


def sql_line_at_offset(text: str, pos: int) -> int:
    """Map a 0-based byte offset in executed SQL to a 1-based line number."""
    if pos <= 0 or not text:
        return 0
    if pos > len(text):
        pos = len(text)
    return text[:pos].count("\n") + 1


def format_sql_error(
    error: str,
    *,
    filepath: str = "",
    sql_root: str = "",
    sql: str = "",
    statement_position: int = 0,
) -> str:
    """Full multiline SQL failure message (no truncation)."""
    lines: list[str] = []
    short = shorten_path(filepath, sql_root) if filepath else ""
    if short:
        header = f"FAILED  {short}"
        if statement_position > 0 and sql:
            line_no = sql_line_at_offset(sql, statement_position)
            if line_no > 0:
                header += f"  (line ~{line_no})"
        lines.append(header)

    err = (error or "").strip()
    if err:
        lines.extend(err.splitlines())
    elif not lines:
        lines.append("FAILED  (unknown error)")

    return "\n".join(lines)


def format_failure(
    path: str,
    error: str,
    *,
    sql_root: str = "",
    sql: str = "",
    statement_position: int = 0,
) -> str:
    return format_sql_error(
        error,
        filepath=path,
        sql_root=sql_root,
        sql=sql,
        statement_position=statement_position,
    )
