#!/usr/bin/env python3
"""Detect i18n text changes by comparing origin PostgreSQL schemas with API baseline.

Workflow (CI)::

  1. GET  /api/i18n/messages          — full i18n baseline in one call (no query params)
  2. Read origin schemas (PostgreSQL) — ws_trans, ud_trans, etc.
  3. Classify new / changed / deleted rows
  4. POST /api/i18n/cat_*_text        — upload detections (external API)

Authentication uses the same cookie session as scripts/i18n_export_zips.py.
Credentials: TRANSLATIONS_API_URL, TRANSLATIONS_API_USER, TRANSLATIONS_API_PASSWORD.

Origin database: ORIGIN_PG_CONN or --origin-conn (default in CI: GW_CONN).
"""

from __future__ import annotations

import argparse
import ast
import hashlib
import json
import logging
import os
import re
import sys
import psycopg2
import psycopg2.extras
from dataclasses import dataclass, field
from enum import Enum
from itertools import product
from pathlib import Path
from typing import Any, Callable, Iterable, Optional

from i18n_api_client import (
    DEFAULT_CHANGED_PATH,
    DEFAULT_DELETED_PATH,
    DEFAULT_MESSAGES_PATH,
    DEFAULT_NEW_PATH,
    primary_keys_from_row,
    TranslationsApiClient,
    fetch_i18n_messages,
    resolve_setting,
    upload_detection_records,
)

_SCRIPT_DIR = Path(__file__).resolve().parent
if str(_SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(_SCRIPT_DIR))


log = logging.getLogger(__name__)

SKIP_FOLDER_NAMES = {"packages", "resources"}

TRANSLATABLE_JSON_KEYS = frozenset(
    {"label", "tooltip", "placeholder", "text", "comboNames", "vdefault_value"}
)

_FIELDS = ("message", "msg", "title")
_PATTERNS = ("=", " =", "= ", " = ")
_QUOTES = ('"', "'", "(")
_KEYS: tuple[str, ...] = tuple(
    f"{f}{p}{q}" for f, p, q in product(_FIELDS, _PATTERNS, _QUOTES)
)
# "message" must precede "msg" so "message = ..." is not treated as msg.
_FIELD_LINE_RE = re.compile(r"^(message|msg|title)\s*=")
_FSTRING_LITERAL_RE = re.compile(r'f["\']')

_QUOTED_SEGMENTS_RE = re.compile(r"(['\"])(.*?)\1")
_TAG_TEXT_RE = re.compile(r">(.*?)<")
_TAG_ACTION_BLOCK_RE = re.compile(r'<action name="([^"]+)">(.*?)</action>', re.DOTALL)
_TAG_PROPERTY_TEXT_RE = re.compile(r'<property name="text">\s*<string>(.*?)</string>', re.DOTALL)
_TAG_BTN_WIDGET_RE = re.compile(
    r'<widget class="QPushButton" name="(btn_[^"]+)">(.*?)</widget>', re.DOTALL
)
_WIDGET_NAME_RE = re.compile(r'name="(.*?)"')
_DBSTYLE_LABEL_RE = re.compile(r'rule.*label="([^"]*)"')


class SourceType(str, Enum):
    PYTHON = "python"
    UI_DIALOG = "ui_dialog"
    DB = "db"


class UpdateKind(str, Enum):
    NEW = "new"
    TEXT_CHANGED = "changed"
    DELETED = "deleted"


@dataclass
class SourceLocation:
    file_path: str = ""
    repo_relative: str = ""
    line_number: int = 0
    enclosing_function: Optional[str] = None
    enclosing_class: Optional[str] = None
    field_name: str = ""
    quote_char: str = ""
    source_line: str = ""


@dataclass
class DbLocation:
    table_i18n: str
    primary_key: dict[str, Any]
    table_org: str = ""
    schema_org: str = ""
    project_type: str = ""
    columns: dict[str, Any] = field(default_factory=dict)
    previous_columns: dict[str, Any] = field(default_factory=dict)


@dataclass
class ExtractedString:
    source_type: SourceType
    original_text: str
    translation_key: str
    identifier: str
    update_kind: UpdateKind
    column_id: str = ""
    previous_text: Optional[str] = None
    location: Optional[SourceLocation] = None
    db_location: Optional[DbLocation] = None


@dataclass
class PythonScanStats:
    assignment_lines: int = 0
    extraction_events: int = 0
    duplicate_occurrences: int = 0

    @property
    def unique_strings(self) -> int:
        return self.extraction_events - self.duplicate_occurrences


@dataclass
class PythonScanResult:
    messages: dict[str, SourceLocation]
    stats: PythonScanStats = field(default_factory=PythonScanStats)


@dataclass
class SearcherConfig:
    repo_root: Path
    project_types: list[str]
    origin_schemas: dict[str, str]
    include_su_tables: bool = True
    dry_run: bool = False

    @property
    def effective_scan_root(self) -> Path:
        return self.repo_root


# region Table catalog

@dataclass(frozen=True)
class TableColumns:
    """Columns that align one i18n table with an origin table."""

    i18n: tuple[str, ...]
    origin: tuple[str, ...]


_PROJECT_TABLES: dict[str, tuple[tuple[str, ...], tuple[str, ...]]] = {
    "ws": (
        (
            "dbconfig_csv", "dbconfig_param_system", "dbconfig_form_fields",
            "dbconfig_typevalue", "dbfprocess", "dbmessage", "dbparam_user",
            "dbconfig_form_tabs", "dbconfig_report", "dbconfig_toolbox",
            "dbfunction", "dbtypevalue", "dbconfig_form_tableview",
            "dbconfig_visit_parameter", "dbtable", "dbconfig_form_fields_feat",
            "su_basic_tables", "dblabel", "dbplan_price", "dbjson",
            "dbconfig_form_fields_json",
        ),
        ("su_basic_tables", "su_feature"),
    ),
    "ud": (
        (
            "dbparam_user", "dbconfig_param_system", "dbconfig_form_fields",
            "dbconfig_typevalue", "dbfprocess", "dbmessage", "dbconfig_csv",
            "dbconfig_form_tabs", "dbconfig_report", "dbconfig_toolbox",
            "dbfunction", "dbtypevalue", "dbconfig_form_tableview",
            "dbconfig_visit_parameter", "dbtable", "dbconfig_form_fields_feat",
            "su_basic_tables", "dblabel", "dbplan_price", "dbjson",
            "dbconfig_form_fields_json",
        ),
        ("su_basic_tables", "su_feature"),
    ),
    "am": (("dbconfig_engine", "dbconfig_form_tableview", "su_basic_tables"), ()),
    "cm": (
        (
            "dbconfig_form_fields", "dbconfig_form_tabs", "dbconfig_param_system",
            "dbtypevalue", "dbfprocess", "dbtable", "dbconfig_form_tableview",
            "dbconfig_form_fields_json",
        ),
        (),
    ),
}

_TABLE_COLUMNS: dict[str, TableColumns] = {
    "dbconfig_form_fields": TableColumns(
        ("formname", "formtype", "tabname", "source", "lb_en_us", "tt_en_us"),
        ("formname", "formtype", "tabname", "columnname", "label", "tooltip"),
    ),
    "dbparam_user": TableColumns(("source", "lb_en_us", "tt_en_us"), ("id", "label", "descript")),
    "dbconfig_param_system": TableColumns(
        ("source", "lb_en_us", "tt_en_us"), ("parameter", "label", "descript")
    ),
    "dbconfig_typevalue": TableColumns(("formname", "source", "tt_en_us"), ("typevalue", "id", "idval")),
    "dblabel": TableColumns(("CAST(source AS INTEGER) AS source", "vl_en_us"), ("id", "idval")),
    "dbmessage": TableColumns(
        ("CAST(source AS INTEGER) AS source", "ms_en_us", "ht_en_us"),
        ("id", "error_message", "hint_message"),
    ),
    "dbfprocess": TableColumns(
        ("CAST(source AS INTEGER) AS source", "ex_en_us", "in_en_us", "na_en_us"),
        ("fid", "except_msg", "info_msg", "fprocess_name"),
    ),
    "dbconfig_csv": TableColumns(
        ("CAST(source AS INTEGER) AS source", "al_en_us", "ds_en_us"), ("fid", "alias", "descript")
    ),
    "dbconfig_form_tabs": TableColumns(
        ("formname", "source", "lb_en_us", "tt_en_us"), ("formname", "tabname", "label", "tooltip")
    ),
    "dbconfig_report": TableColumns(
        ("CAST(source AS INTEGER) AS source", "al_en_us", "ds_en_us"), ("id", "alias", "descript")
    ),
    "dbconfig_toolbox": TableColumns(
        ("CAST(source AS INTEGER) AS source", "al_en_us", "ob_en_us"), ("id", "alias", "observ")
    ),
    "dbfunction": TableColumns(("CAST(source AS INTEGER) AS source", "ds_en_us"), ("id", "descript")),
    "dbtypevalue": TableColumns(
        ("typevalue", "source", "vl_en_us", "ds_en_us"), ("typevalue", "id", "idval", "descript")
    ),
    "dbconfig_form_tableview": TableColumns(
        ("columnname", "source", "al_en_us"), ("columnname", "objectname", "alias")
    ),
    "dbtable": TableColumns(("source", "ds_en_us", "al_en_us"), ("id", "descript", "alias")),
    "dbplan_price": TableColumns(
        ("source", "ds_en_us", "tx_en_us", "pr_en_us"), ("id", "descript", "text", "price")
    ),
    "dbconfig_visit_parameter": TableColumns(("source", "ds_en_us"), ("id", "descript")),
    "su_feature": TableColumns(
        ("feature_class", "feature_type", "lb_en_us", "ds_en_us"),
        ("feature_class", "feature_type", "id", "descript"),
    ),
    "dbconfig_engine": TableColumns(
        ("parameter", "method", "lb_en_us", "ds_en_us", "pl_en_us"),
        ("parameter", "method", "label", "descript", "placeholder"),
    ),
    "dbstyle": TableColumns(
        ("source", "layername", "org_text", "hint", "lb_en_us"),
        ("styleconfig_id", "layername", "stylevalue"),
    ),
}
_DEFAULT_TABLE_COLUMNS = TableColumns(("source", "lb_en_us"), ("id", "label"))
_I18N_METADATA_COLUMNS = ("project_type", "source_code", "context")


def tables_dic(schema_type: str) -> tuple[list[str], list[str]]:
    """Return copies so callers may safely append optional tables."""
    dbtables, sutables = _PROJECT_TABLES[schema_type]
    return list(dbtables), list(sutables)


def _su_basic_table_columns(table_org: str, project_type: str) -> TableColumns:
    if table_org == "value_state" and project_type in ("ud", "ws"):
        return TableColumns(("source", "na_en_us", "ob_en_us"), ("id", "name", "observ"))
    if project_type == "am":
        return TableColumns(("source", "na_en_us"), ("id", "idval"))
    return TableColumns(("source", "na_en_us"), ("id", "name"))


def get_columns_to_compare(table_i18n: str, table_org: str, project_type: str) -> tuple[list[str], list[str]]:
    """Return i18n and origin columns, including common i18n metadata."""
    table_name = table_i18n.split(".")[-1]
    columns = (
        _su_basic_table_columns(table_org, project_type)
        if table_name == "su_basic_tables"
        else _TABLE_COLUMNS.get(table_name, _DEFAULT_TABLE_COLUMNS)
    )
    return [*columns.i18n, *_I18N_METADATA_COLUMNS], list(columns.origin)


def _normalize_i18n_columns(columns_i18n: list[str]) -> list[str]:
    result = []
    for col in columns_i18n:
        if "CAST(" in col:
            result.append(col[5:].split(" ")[0])
        else:
            result.append(col)
    return result


_ORIGIN_TABLES: dict[str, tuple[str, ...]] = {
    "dbjson": ("config_report", "config_toolbox"),
    "dbplan_price": ("plan_price",),
    "dbstyle": ("sys_style",),
    "dbconfig_form_fields_json": ("config_form_fields",),
    "dbconfig_form_fields_feat": ("config_form_fields",),
    "dbconfig_engine": ("config_engine", "config_engine_def"),
}
_TYPEVALUE_ORIGIN_TABLES: dict[str, tuple[str, ...]] = {
    "am": ("sys_typevalue",),
    "cm": ("sys_typevalue",),
    "ws": ("edit_typevalue", "plan_typevalue", "om_typevalue", "inp_typevalue"),
    "ud": ("edit_typevalue", "plan_typevalue", "om_typevalue", "inp_typevalue"),
}
_SU_ORIGIN_TABLES: dict[str, tuple[str, ...]] = {
    "su_feature": ("cat_feature",),
    "su_basic_tables": ("value_state", "value_state_type"),
}


def find_table_org(table_i18n: str, project_type: str) -> list[str]:
    table_name = table_i18n.split(".")[-1]
    if table_name == "dbtypevalue":
        return list(_TYPEVALUE_ORIGIN_TABLES.get(project_type, ()))
    if table_name in _ORIGIN_TABLES:
        return list(_ORIGIN_TABLES[table_name])
    if table_name.startswith("dbconfig"):
        return [table_name[2:]]
    if table_name.startswith("su_"):
        if project_type == "am":
            return ["value_result_type", "value_status"]
        return list(_SU_ORIGIN_TABLES.get(table_name, ()))
    return [f"sys_{table_name[2:]}" if table_name.startswith("db") else table_name]


def find_table_org_with_context(
    i18n_rows: list[dict],
    table_name: str,
    project_type: str,
) -> list[str]:
    tables_org = find_table_org(table_name, project_type)
    if table_name.startswith("su_"):
        return tables_org
    seen_contexts = set(tables_org)
    for row in i18n_rows:
        if row.get("project_type") != project_type:
            continue
        context = row.get("context")
        if context and context not in seen_contexts:
            tables_org.append(str(context))
            seen_contexts.add(str(context))
    return tables_org

# endregion


# region Shared scan helpers

def _find_files(path: Path, file_type: str, extra_avoid_list: list[str] = []) -> list[Path]:
    result: list[Path] = []
    avoid_list = list(SKIP_FOLDER_NAMES) + extra_avoid_list
    for folder, subfolders, files in os.walk(path):
        # Prune skipped folders so their whole subtree is never visited
        subfolders[:] = [d for d in subfolders if d not in avoid_list]
        if Path(folder).name in avoid_list:
            continue
        for fname in files:
            if fname.endswith(file_type):
                result.append(Path(folder) / fname)
    return sorted(result)


def _read_stripped_lines(file_path: Path) -> Optional[list[str]]:
    try:
        with open(file_path, encoding="utf-8") as f:
            return [line.strip() for line in f]
    except OSError as exc:
        log.warning("Cannot read %s: %s", file_path, exc)
        return None


def _search_for_lines(message: str) -> list[str]:
    if "\\n" in message:
        return message.split("\\n")
    return [message]


def _contains_fstring_literal(text: str) -> bool:
    """True when the assignment uses an f-string literal (must not be translated as-is)."""
    return bool(_FSTRING_LITERAL_RE.search(text))


def _msg_multiline_end(
    found_lines: list,
    full_text: str,
    num_line: int,
    field_name: str = "msg",
) -> list:
    if _contains_fstring_literal(full_text):
        return found_lines
    matches = _QUOTED_SEGMENTS_RE.findall(full_text)
    if matches:
        final_text = f'{field_name} = "' + "".join(m[1] for m in matches) + '"'
        found_lines.append((num_line, final_text))
    else:
        found_lines.append((num_line, full_text.strip()))
    return found_lines


def _scan_key(
    stripped_lines: list[str], key: str, candidates: Iterable[int]
) -> list[tuple[int, str]]:
    """Baseline _search_lines scan for one key over pre-read, pre-stripped lines.

    `candidates` holds the indexes of lines that can start a match (lines
    beginning with the key's field name); multiline accumulation still consumes
    every following line, exactly like the baseline sequential scan.
    """
    found_lines: list[tuple[int, str]] = []
    is_paren = "(" in key
    field_name = _parse_field_from_key(key)
    total = len(stripped_lines)
    consumed_until = -1  # last line swallowed by a multiline block

    for idx in candidates:
        if idx <= consumed_until:
            continue
        line = stripped_lines[idx]
        if not line.startswith(key):
            continue
        if _contains_fstring_literal(line):
            continue
        if not is_paren:
            content = line
            pos = idx + 1
            while pos < total:
                next_line = stripped_lines[pos]
                if next_line and next_line[0] in "'\"":
                    content += next_line
                    pos += 1
                else:
                    break
            found_lines.append((idx, content))
            if pos > idx + 1:
                consumed_until = pos - 1
            continue
        if line.endswith(")"):
            found_lines = _msg_multiline_end(found_lines, line, idx, field_name)
            continue
        full_text = line
        pos = idx + 1
        while pos < total:
            full_text += stripped_lines[pos]
            if stripped_lines[pos].endswith(")"):
                found_lines = _msg_multiline_end(found_lines, full_text, pos, field_name)
                break
            pos += 1
        consumed_until = pos

    return found_lines


def _normalize_concatenated_assignment(content: str, field_name: str) -> str:
    """Join adjacent string literals in ``msg = "a" "b"`` style assignments."""
    segments = _QUOTED_SEGMENTS_RE.findall(content)
    if len(segments) <= 1:
        return content
    return f'{field_name} = "' + "".join(part for _quote, part in segments) + '"'


# endregion


# region Python messages (_update_py_messages)

def _build_ast_index(file_path: Path) -> Optional[list[tuple[str, int, int, str]]]:
    """Parse a file once and keep class/function spans in ast.walk order."""
    try:
        source = file_path.read_text(encoding="utf-8")
        tree = ast.parse(source)
    except (OSError, SyntaxError):
        return None

    index: list[tuple[str, int, int, str]] = []
    for node in ast.walk(tree):
        if isinstance(node, ast.ClassDef):
            index.append(
                ("class", node.lineno, getattr(node, "end_lineno", node.lineno), node.name)
            )
        elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            index.append(
                ("func", node.lineno, getattr(node, "end_lineno", node.lineno), node.name)
            )
    return index


def _ast_context(
    ast_index: Optional[list[tuple[str, int, int, str]]], line_number: int
) -> tuple[Optional[str], Optional[str]]:
    """Best-effort enclosing class/function via AST (enrichment only)."""
    if ast_index is None:
        return None, None

    class_name: Optional[str] = None
    func_name: Optional[str] = None
    target_line = line_number + 1  # AST is 1-based

    for kind, start, end, name in ast_index:
        if start <= target_line <= end:
            if kind == "class":
                class_name = name
            else:
                func_name = name
    return func_name, class_name


def _scan_python_messages(
    scan_root: Path,
) -> PythonScanResult:
    """Scan .py files and return unique message strings with source locations."""
    messages: dict[str, SourceLocation] = {}
    stats = PythonScanStats()
    scan_root = scan_root.resolve()

    for file_path in _find_files(scan_root, ".py"):
        file_path = file_path.resolve()
        stripped_lines = _read_stripped_lines(file_path)
        if stripped_lines is None:
            continue

        candidates: dict[str, list[int]] = {field: [] for field in _FIELDS}
        for idx, line in enumerate(stripped_lines):
            field_match = _FIELD_LINE_RE.match(line)
            if field_match:
                candidates[field_match.group(1)].append(idx)
                stats.assignment_lines += 1

        file_path_str: Optional[str] = None
        rel: Optional[str] = None
        ast_index: Optional[list[tuple[str, int, int, str]]] = None
        ast_index_loaded = False

        def register(
            num_line: int,
            message: str,
            *,
            field_name: str,
            quote_char: str,
            source_line: str,
        ) -> None:
            nonlocal file_path_str, rel, ast_index, ast_index_loaded
            stats.extraction_events += 1
            if message in messages:
                stats.duplicate_occurrences += 1
                return
            if file_path_str is None:
                file_path_str = str(file_path)
                rel = str(file_path.relative_to(scan_root))
            if not ast_index_loaded:
                ast_index = _build_ast_index(file_path)
                ast_index_loaded = True
            func, cls = _ast_context(ast_index, num_line)
            messages[message] = SourceLocation(
                file_path=file_path_str,
                repo_relative=rel,
                line_number=num_line,
                enclosing_function=func,
                enclosing_class=cls,
                field_name=field_name,
                quote_char=quote_char,
                source_line=source_line,
            )

        for key in _KEYS:
            field_candidates = candidates[_FIELD_BY_KEY[key]]
            if not field_candidates:
                continue
            extract_key = _EXTRACT_KEY_BY_KEY[key]
            extract_re = _EXTRACT_RE_BY_KEY[key]
            for num_line, content in _scan_key(stripped_lines, key, field_candidates):
                field_name = _FIELD_BY_KEY[key]
                if _contains_fstring_literal(content):
                    continue
                content = _normalize_concatenated_assignment(content, field_name)
                match = extract_re.search(content)
                if not match:
                    continue
                for message in _search_for_lines(match.group(1)):
                    register(
                        num_line,
                        message,
                        field_name=field_name,
                        quote_char=extract_key[-1],
                        source_line=content,
                    )

    return PythonScanResult(messages=messages, stats=stats)


def _pymessage_row(source: str, ms_en_us: str | None = None) -> dict[str, Any]:
    text = ms_en_us if ms_en_us is not None else source
    return {
        "source": source,
        "source_code": "giswater",
        "project_type": "python",
        "context": "pymessage",
        "ms_en_us": text,
    }


def _pymessage_finding(
    source: str,
    update_kind: UpdateKind,
    *,
    location: Optional[SourceLocation] = None,
    previous_text: Optional[str] = None,
    baseline_row: Optional[dict[str, Any]] = None,
) -> ExtractedString:
    ms_en_us = source
    if update_kind == UpdateKind.DELETED and baseline_row is not None:
        ms_en_us = str(baseline_row.get("ms_en_us", source) or source)
    row = _pymessage_row(source, ms_en_us)
    return ExtractedString(
        source_type=SourceType.PYTHON,
        original_text=ms_en_us,
        translation_key=source,
        identifier="pymessage",
        update_kind=update_kind,
        column_id="ms_en_us",
        previous_text=previous_text,
        location=location,
        db_location=DbLocation(
            table_i18n="pymessage",
            primary_key={"source": source, "source_code": "giswater"},
            columns=row,
            previous_columns=dict(baseline_row) if baseline_row is not None else {},
        ),
    )


def _classify_scanned_texts(
    scanned: dict[Any, str],
    baseline_by_key: dict[Any, dict[str, Any]],
    text_column: str,
    *,
    include_deleted: Optional[Callable[[Any], bool]] = None,
) -> list[tuple[Any, str, UpdateKind, Optional[dict[str, Any]]]]:
    """Compare source text with API rows using the source-specific key."""
    classified: list[tuple[Any, str, UpdateKind, Optional[dict[str, Any]]]] = []
    for key, text in scanned.items():
        baseline = baseline_by_key.get(key)
        if baseline is None:
            classified.append((key, text, UpdateKind.NEW, None))
        elif str(baseline.get(text_column, "") or "") != text:
            classified.append((key, text, UpdateKind.TEXT_CHANGED, baseline))
    for key, baseline in baseline_by_key.items():
        if key not in scanned and (include_deleted is None or include_deleted(key)):
            classified.append(
                (key, str(baseline.get(text_column, "") or ""), UpdateKind.DELETED, baseline)
            )
    return classified


def extract_py_candidates(
    i18n_rows: list[dict],
    config: SearcherConfig,
) -> list[ExtractedString]:
    """Compare scanned Python sources against the API pymessage baseline."""
    scan_root = config.repo_root
    scan_result = _scan_python_messages(scan_root)
    scanned = scan_result.messages
    stats = scan_result.stats

    log.info(
        "Py message scan: %d assignment line(s), %d extraction(s), "
        "%d unique string(s) (%d duplicate occurrence(s) collapsed)",
        stats.assignment_lines,
        stats.extraction_events,
        len(scanned),
        stats.duplicate_occurrences,
    )

    baseline_rows = [row for row in i18n_rows if row.get("table_name") == "pymessage"]
    baseline_by_source: dict[str, dict[str, Any]] = {}
    for row in baseline_rows:
        source = str(row.get("source", "") or "")
        if source:
            baseline_by_source[source] = row

    scanned_texts = {source: source for source in scanned}
    findings: list[ExtractedString] = []
    kind_counts = {UpdateKind.NEW: 0, UpdateKind.TEXT_CHANGED: 0, UpdateKind.DELETED: 0}
    for source, _text, update_kind, baseline in _classify_scanned_texts(
        scanned_texts, baseline_by_source, "ms_en_us"
    ):
        kind_counts[update_kind] += 1
        findings.append(
            _pymessage_finding(
                source,
                update_kind,
                location=scanned.get(source),
                previous_text=(
                    str(baseline.get("ms_en_us", "") or "")
                    if update_kind == UpdateKind.TEXT_CHANGED and baseline is not None
                    else None
                ),
                baseline_row=baseline,
            )
        )

    log.info(
        "Py message extraction: %d detection(s) vs baseline "
        "(new=%d, changed=%d, deleted=%d)",
        len(findings),
        kind_counts[UpdateKind.NEW],
        kind_counts[UpdateKind.TEXT_CHANGED],
        kind_counts[UpdateKind.DELETED],
    )

    findings.extend(_extract_pydialog_candidates(i18n_rows, scan_root))
    findings.extend(_extract_py_toolbar_candidates(i18n_rows, scan_root))

    log.info("Python extraction: %d detection(s)", len(findings))
    return findings

# endregion


# region UI dialogs and toolbars (_update_py_dialogs)

def _pydialog_row(
    actual_source: str,
    dialog_name: str,
    toolbar_name: str,
    lb_en_us: str,
) -> dict[str, Any]:
    return {
        "source_code": "giswater",
        "project_type": "utils",
        "dialog_name": dialog_name,
        "toolbar_name": toolbar_name,
        "source": actual_source,
        "lb_en_us": lb_en_us,
    }


def _pydialog_finding(
    actual_source: str,
    dialog_name: str,
    toolbar_name: str,
    update_kind: UpdateKind,
    *,
    original_text: str,
    previous_text: Optional[str] = None,
    baseline_row: Optional[dict[str, Any]] = None,
) -> ExtractedString:
    row = _pydialog_row(actual_source, dialog_name, toolbar_name, original_text)
    return ExtractedString(
        source_type=SourceType.UI_DIALOG,
        original_text=original_text,
        translation_key=actual_source,
        identifier="pydialog",
        update_kind=update_kind,
        column_id="lb_en_us",
        previous_text=previous_text,
        db_location=DbLocation(
            table_i18n="pydialog",
            project_type="utils",
            primary_key={
                "dialog_name": dialog_name,
                "toolbar_name": toolbar_name,
                "source": actual_source,
                "source_code": "giswater",
                "project_type": "utils",
            },
            columns=row,
            previous_columns=dict(baseline_row) if baseline_row is not None else {},
        ),
    )


def _pytoolbar_row(source: str, lb_en_us: str) -> dict[str, Any]:
    return {
        "source": source,
        "source_code": "giswater",
        "lb_en_us": lb_en_us,
    }


def _pytoolbar_finding(
    source: str,
    update_kind: UpdateKind,
    *,
    original_text: str,
    previous_text: Optional[str] = None,
    baseline_row: Optional[dict[str, Any]] = None,
) -> ExtractedString:
    if update_kind == UpdateKind.DELETED and baseline_row is not None:
        original_text = str(baseline_row.get("lb_en_us", original_text) or original_text)
    row = _pytoolbar_row(source, original_text)
    return ExtractedString(
        source_type=SourceType.UI_DIALOG,
        original_text=original_text,
        translation_key=source,
        identifier="pytoolbar",
        update_kind=update_kind,
        column_id="lb_en_us",
        previous_text=previous_text,
        db_location=DbLocation(
            table_i18n="pytoolbar",
            primary_key={"source": source, "source_code": "giswater"},
            columns=row,
            previous_columns=dict(baseline_row) if baseline_row is not None else {},
        ),
    )


def _pytoolbar_scannable(source: str) -> bool:
    return source.startswith("btn_") or source.startswith("action")


def _baseline_by_table(
    i18n_rows: list[dict],
    table_name: str,
) -> list[dict[str, Any]]:
    return [row for row in i18n_rows if row.get("table_name") == table_name]

def _index_widget_context(raw_lines: list[str]) -> list[tuple[int, bool]]:
    """For each line, the nearest preceding <widget line and whether an
    <action name= line blocks the upward walk (baseline _search_dialog_info)."""
    context: list[tuple[int, bool]] = []
    widget_line = -1
    blocked = False
    for line in raw_lines:
        if "<widget" in line:
            widget_line, blocked = len(context), False
        elif "<action name=" in line:
            blocked = True
        context.append((widget_line, blocked))
    return context


def _search_dialog_info(
    file_path: Path,
    raw_lines: list[str],
    widget_context: list[tuple[int, bool]],
    num_line: int,
) -> tuple[str, str, str | bool]:
    toolbar_name = file_path.parent.name
    dialog_name = file_path.stem

    widget_line, blocked = widget_context[num_line]
    if blocked:
        return dialog_name, toolbar_name, False
    if widget_line < 0:
        return dialog_name, toolbar_name, ""

    match = _WIDGET_NAME_RE.search(raw_lines[widget_line])
    source = match.group(1) if match else ""
    return dialog_name, toolbar_name, source


def _scan_ui_dialogs(
    scan_root: Path,
) -> dict[tuple[str, str, str], str]:
    processed: dict[tuple[str, str, str], str] = {}
    scan_root = scan_root.resolve()

    for file_path in _find_files(scan_root, ".ui"):
        file_path = file_path.resolve()
        try:
            with open(file_path, encoding="utf-8") as f:
                raw_lines = f.readlines()
        except OSError as exc:
            log.warning("Cannot read %s: %s", file_path, exc)
            continue

        widget_context = _index_widget_context(raw_lines)
        for num_line, raw_line in enumerate(raw_lines):
            content = raw_line.strip()
            if not content.startswith("<string>"):
                continue
            dialog_name, toolbar_name, source = _search_dialog_info(
                file_path, raw_lines, widget_context, num_line
            )
            if source is False:
                continue
            match = _TAG_TEXT_RE.search(content)
            if not match:
                continue
            message_text = match.group(1)
            if source.startswith("dlg_") or source == dialog_name:
                actual_source = f"dlg_{dialog_name}"
            else:
                actual_source = str(source)
            processed[(actual_source, dialog_name, toolbar_name)] = message_text

    processed[("btn_help", "common", "common")] = "Help"
    return processed


def _extract_pydialog_candidates(
    i18n_rows: list[dict],
    scan_root: Path,
) -> list[ExtractedString]:
    scanned = _scan_ui_dialogs(scan_root.joinpath("core", "ui"))
    baseline_rows = _baseline_by_table(i18n_rows, "pydialog")
    baseline_by_key: dict[tuple[str, str, str], dict[str, Any]] = {}
    for row in baseline_rows:
        key = (
            str(row.get("source", "") or ""),
            str(row.get("dialog_name", "") or ""),
            str(row.get("toolbar_name", "") or ""),
        )
        if key[0]:
            baseline_by_key[key] = row

    findings: list[ExtractedString] = []
    for key, label, update_kind, baseline in _classify_scanned_texts(
        scanned,
        baseline_by_key,
        "lb_en_us",
        include_deleted=lambda dialog_key: dialog_key[0] != "dlg_admin",
    ):
        actual_source, dialog_name, toolbar_name = key
        findings.append(
            _pydialog_finding(
                actual_source,
                dialog_name,
                toolbar_name,
                update_kind,
                original_text=label,
                previous_text=(
                    str(baseline.get("lb_en_us", "") or "")
                    if update_kind == UpdateKind.TEXT_CHANGED and baseline is not None
                    else None
                ),
                baseline_row=baseline,
            )
        )

    log.info("UI dialog extraction: %d detection(s)", len(findings))
    return findings


def _scan_py_toolbars(scan_root: Path) -> dict[str, str]:
    labels: dict[str, str] = {}
    for file_path in _find_files(scan_root.resolve(), ".ui"):
        try:
            content = file_path.read_text(encoding="utf-8")
        except OSError as exc:
            log.warning("Cannot read %s: %s", file_path, exc)
            continue
        for action_match in _TAG_ACTION_BLOCK_RE.finditer(content):
            source = action_match.group(1)
            block = action_match.group(2)
            text_match = _TAG_PROPERTY_TEXT_RE.search(block)
            if text_match:
                labels[source] = text_match.group(1).strip()
        for widget_match in _TAG_BTN_WIDGET_RE.finditer(content):
            source = widget_match.group(1)
            block = widget_match.group(2)
            text_match = _TAG_PROPERTY_TEXT_RE.search(block)
            if text_match:
                labels[source] = text_match.group(1).strip()
    return labels


def _extract_py_toolbar_candidates(
    i18n_rows: list[dict],
    scan_root: Path,
) -> list[ExtractedString]:
    scanned = _scan_py_toolbars(scan_root)
    baseline_rows = _baseline_by_table(i18n_rows, "pytoolbar")
    baseline_by_source: dict[str, dict[str, Any]] = {}
    for row in baseline_rows:
        source = str(row.get("source", "") or "")
        if source:
            baseline_by_source[source] = row

    findings: list[ExtractedString] = []
    for source, label, update_kind, baseline in _classify_scanned_texts(
        scanned,
        baseline_by_source,
        "lb_en_us",
        include_deleted=_pytoolbar_scannable,
    ):
        findings.append(
            _pytoolbar_finding(
                source,
                update_kind,
                original_text=label,
                previous_text=(
                    str(baseline.get("lb_en_us", "") or "")
                    if update_kind == UpdateKind.TEXT_CHANGED and baseline is not None
                    else None
                ),
                baseline_row=baseline,
            )
        )

    log.info("Py toolbar extraction: %d detection(s)", len(findings))
    return findings


# region Origin PostgreSQL

class OriginDb:
    def __init__(self, conninfo: str) -> None:
        self.conninfo = conninfo
        self._conn = psycopg2.connect(conninfo)
        self._conn.autocommit = True

    def close(self) -> None:
        self._conn.close()

    def fetch_all(self, sql: str) -> list[dict[str, Any]]:
        with self._conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql)
            return [dict(row) for row in cur.fetchall()]

    def table_exists(self, schema: str, table: str) -> bool:
        rows = self.fetch_all(
            "SELECT EXISTS ("
            "  SELECT 1 FROM information_schema.tables "
            f"  WHERE table_schema = '{schema}' AND table_name = '{table}'"
            ") AS exists"
        )
        return bool(rows and rows[0].get("exists"))

    def schema_exists(self, schema: str) -> bool:
        rows = self.fetch_all(
            "SELECT EXISTS ("
            "  SELECT 1 FROM information_schema.schemata "
            f"  WHERE schema_name = '{schema}'"
            ") AS exists"
        )
        return bool(rows and rows[0].get("exists"))

    def verify_lang(self, schema: str) -> bool:
        if not self.table_exists(schema, "sys_version"):
            return False
        rows = self.fetch_all(f"SELECT language FROM {schema}.sys_version ORDER BY id DESC LIMIT 1")
        if not rows:
            return False
        lang = str(rows[0].get("language", "")).lower()
        return lang in ("en_us", "no_tr")

    def schema_version(self, schema: str) -> str:
        if not self.table_exists(schema, "sys_version"):
            return ""
        rows = self.fetch_all(f"SELECT giswater FROM {schema}.sys_version ORDER BY id DESC LIMIT 1")
        if not rows:
            return ""
        return str(rows[0].get("giswater", "") or "")

# endregion


# region Row comparison helpers

def _parse_field_from_key(key: str) -> str:
    match = _FIELD_LINE_RE.match(key)
    if match:
        return match.group(1)
    for fld in _FIELDS:
        if key.startswith(fld):
            return fld
    return "msg"


def _extract_key_for(key: str) -> str:
    field = _parse_field_from_key(key)
    if "(" in key:
        return f'{field} = "'
    return key


_FIELD_BY_KEY = {key: _parse_field_from_key(key) for key in _KEYS}
_EXTRACT_KEY_BY_KEY = {key: _extract_key_for(key) for key in _KEYS}
_EXTRACT_RE_BY_KEY = {
    key: re.compile(rf"{re.escape(ek)}(.*?){ek[-1]}")
    for key, ek in _EXTRACT_KEY_BY_KEY.items()
}


def _normalize_cell_value(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value).strip()


def _dict_to_values_tuple(d: dict, keys: list[str]) -> tuple:
    return tuple(_normalize_cell_value(d.get(k, "")) for k in keys)


def _pk_columns(keys: list[str]) -> list[str]:
    return [k for k in keys if "en_us" not in k]


def _set_diff_rows(rows_a: list[dict], rows_b: list[dict], keys: list[str]) -> list[dict]:
    set_b = {_dict_to_values_tuple(r, keys) for r in rows_b}
    set_a = {_dict_to_values_tuple(r, keys) for r in rows_a}
    diff_tuples = set_a - set_b
    return [r for r in rows_a if _dict_to_values_tuple(r, keys) in diff_tuples]


def _classify_diff_rows(
    rows_org: list[dict],
    rows_i18n: list[dict],
    keys: list[str],
) -> list[tuple[dict, UpdateKind, Optional[dict]]]:
    pk_keys = _pk_columns(keys)
    i18n_by_pk = {_dict_to_values_tuple(row, pk_keys): row for row in rows_i18n}
    classified: list[tuple[dict, UpdateKind, Optional[dict]]] = []
    for row in _set_diff_rows(rows_org, rows_i18n, keys):
        previous = i18n_by_pk.get(_dict_to_values_tuple(row, pk_keys))
        if previous is not None:
            classified.append((row, UpdateKind.TEXT_CHANGED, previous))
        else:
            classified.append((row, UpdateKind.NEW, None))
    return classified


def _classify_deleted_rows(
    rows_org: list[dict],
    rows_i18n: list[dict],
    keys: list[str],
    findings: list[ExtractedString],
) -> list[dict]:
    """Rows in i18n baseline whose PK no longer exists in aligned org rows."""
    pk_keys = _pk_columns(keys)
    text_changed_pks: set[tuple] = set()
    for finding in findings:
        if (
            finding.update_kind == UpdateKind.TEXT_CHANGED
            and finding.db_location is not None
        ):
            text_changed_pks.add(
                _dict_to_values_tuple(finding.db_location.primary_key, pk_keys)
            )

    deleted: list[dict] = []
    for row in _set_diff_rows(rows_i18n, rows_org, keys):
        if _dict_to_values_tuple(row, pk_keys) in text_changed_pks:
            continue
        deleted.append(row)
    return deleted


def _org_i18n_column_pairs(columns_org: list[str], columns_i18n: list[str]) -> list[tuple[str, str]]:
    compare_i18n = _normalize_i18n_columns(columns_i18n[: max(0, len(columns_i18n) - 3)])
    pairs: list[tuple[str, str]] = []
    for i, org_col in enumerate(columns_org):
        if i >= len(compare_i18n):
            break
        i18n_col = compare_i18n[i]
        if i18n_col not in ("project_type", "source_code", "context"):
            pairs.append((i18n_col, org_col))
    return pairs


def _clean_rows_org(rows_org: list[dict], columns_org: list[str], project_type: str, table_org: str) -> list[dict]:
    cleaned = []
    extra = {"project_type": project_type, "source_code": "giswater", "context": table_org}
    all_cols = set(columns_org) | set(extra)
    for row in rows_org:
        clean_row = dict(row)
        clean_row.update(extra)
        for col in all_cols:
            val = clean_row.get(col, "")
            if val is None:
                clean_row[col] = ""
            if project_type == "cm" and col == "id" and table_org == "sys_table":
                parts = str(val).split("_")
                if len(parts) >= 2:
                    clean_row[col] = parts[-2] + "_" + parts[-1]
        cleaned.append(clean_row)
    return cleaned


def _clean_rows_i18n(rows_i18n: list[dict], columns_i18n: list[str], project_type: str, table_i18n: str) -> list[dict]:
    cleaned = []
    for row in rows_i18n:
        clean_row = dict(row)
        for col in columns_i18n:
            val = clean_row.get(col, "")
            if val is None:
                clean_row[col] = ""
            if project_type == "cm" and col == "source" and "dbtable" in table_i18n:
                parts = str(val).split("_")
                if len(parts) >= 2:
                    clean_row[col] = parts[-2] + "_" + parts[-1]
        cleaned.append(clean_row)
    return cleaned


def _align_org_rows(
    rows_org: list[dict],
    columns_org: list[str],
    columns_i18n: list[str],
    project_type: str,
    table_org: str,
    is_dbstyle: bool,
) -> list[dict]:
    pairs = _org_i18n_column_pairs(columns_org, columns_i18n)
    aligned_org: list[dict] = []
    for row in rows_org:
        aligned: dict[str, Any] = {
            i18n_col: row.get(org_col, "") for i18n_col, org_col in pairs
        }
        aligned["project_type"] = row.get("project_type", project_type)
        aligned["source_code"] = row.get("source_code", "giswater")
        aligned["context"] = row.get("context", table_org)
        if "hint" in row:
            aligned["hint"] = row["hint"]
        if "lb_en_us" in row and is_dbstyle:
            aligned["lb_en_us"] = row["lb_en_us"]
        aligned_org.append(aligned)
    return aligned_org


def _findings_from_db_row(
    row: dict,
    table_name: str,
    table_org: str,
    schema_org: str,
    project_type: str,
    columns_i18n: list[str],
    *,
    update_kind: UpdateKind = UpdateKind.NEW,
    previous_row: Optional[dict] = None,
) -> list[ExtractedString]:
    """Build one detection per translatable column (GET-shaped payloads)."""
    en_us_columns = [c for c in columns_i18n if "en_us" in c]
    pk = primary_keys_from_row(table_name, row)
    base_location = dict(
        table_i18n=table_name,
        table_org=table_org,
        schema_org=schema_org,
        project_type=project_type,
        primary_key=pk,
        columns=dict(row),
    )
    findings: list[ExtractedString] = []

    def _append(col: str, text: str, previous: Optional[str] = None) -> None:
        if not text and update_kind != UpdateKind.TEXT_CHANGED:
            return
        findings.append(
            ExtractedString(
                source_type=SourceType.DB,
                original_text=text,
                translation_key=str(pk.get("source", "")),
                identifier=table_name,
                update_kind=update_kind,
                column_id=col,
                previous_text=previous,
                db_location=DbLocation(
                    **base_location,
                    previous_columns=dict(previous_row) if previous_row is not None else {},
                ),
            )
        )

    if update_kind == UpdateKind.TEXT_CHANGED:
        if previous_row is None:
            return []
        for col in en_us_columns:
            new_val = str(row.get(col, "") or "")
            old_val = str(previous_row.get(col, "") or "")
            if new_val != old_val:
                _append(col, new_val, old_val)
        return findings

    if update_kind == UpdateKind.DELETED:
        for col in en_us_columns:
            val = str(row.get(col, "") or "")
            _append(col, val)
        return findings

    # NEW — one record per non-empty *_en_us column
    for col in en_us_columns:
        val = str(row.get(col, "") or "")
        _append(col, val)
    return findings


def _compare_db_rows(
    expected_rows: list[dict],
    baseline_rows: list[dict],
    columns_i18n: list[str],
    *,
    table_name: str,
    table_org: str,
    schema_org: str,
    project_type: str,
) -> list[ExtractedString]:
    """Classify aligned rows and emit findings for all three update kinds."""
    findings: list[ExtractedString] = []
    for row, update_kind, previous_row in _classify_diff_rows(
        expected_rows, baseline_rows, columns_i18n
    ):
        findings.extend(
            _findings_from_db_row(
                row,
                table_name,
                table_org,
                schema_org,
                project_type,
                columns_i18n,
                update_kind=update_kind,
                previous_row=previous_row,
            )
        )
    for row in _classify_deleted_rows(expected_rows, baseline_rows, columns_i18n, findings):
        findings.extend(
            _findings_from_db_row(
                row,
                table_name,
                table_org,
                schema_org,
                project_type,
                columns_i18n,
                update_kind=UpdateKind.DELETED,
            )
        )
    return findings

# endregion


# region Detection records and upload

def sort_keys_deep(value: object) -> object:
    if value is None or not isinstance(value, (dict, list)):
        return value
    if isinstance(value, list):
        return [sort_keys_deep(item) for item in value]
    return {
        key: sort_keys_deep(value[key])  # type: ignore[index]
        for key in sorted(value.keys())  # type: ignore[union-attr]
    }

_PY_TABLES = frozenset({"pymessage", "pytoolbar", "pydialog"})
# Internal-only columns on py* rows; omitted from POST body per post-detections-python.md.
_PY_POST_OMIT_COLUMNS = frozenset({"context", "project_type", "table_org", "schema_org"})


def _py_post_fields(table_name: str, loc: DbLocation) -> dict[str, str]:
    """Extra top-level POST fields for py* tables (post-detections-python.md)."""
    if table_name == "pydialog":
        project_type = loc.project_type or str(loc.columns.get("project_type", "") or "utils")
        return {"project_type": project_type}
    return {}


def _include_pk_field(table_name: str, column: str) -> bool:
    if table_name in _PY_TABLES and column in _PY_POST_OMIT_COLUMNS:
        return False
    return True


def compute_detection_key(
    loc: DbLocation,
    finding: ExtractedString,
    normalized_primary_keys: dict[str, Any],
) -> str:
    payload: dict[str, Any] = {
        "table_name": loc.table_i18n,
        "primary_keys": dict(sorted(normalized_primary_keys.items())),
        "column_id": finding.column_id,
        "kind": finding.update_kind,
    }
    if loc.table_i18n == "pydialog":
        post_fields = _py_post_fields(loc.table_i18n, loc)
        payload["project_type"] = post_fields["project_type"]
    elif loc.table_i18n not in _PY_TABLES:
        payload["table_org"] = loc.table_org
        payload["schema_org"] = loc.schema_org
        payload["project_type"] = loc.project_type
    payload = sort_keys_deep(payload)
    serialized = json.dumps(payload, separators=(",", ":"), ensure_ascii=False)
    return hashlib.sha256(serialized.encode("utf-8")).hexdigest()


def finding_to_record(finding: ExtractedString, detected_version: str) -> dict[str, Any]:
    if finding.db_location is None:
        raise ValueError("DB finding missing db_location")
    if not finding.column_id:
        raise ValueError("DB finding missing column_id")
    loc = finding.db_location
    col = finding.column_id
    normalized_primary_keys = primary_keys_from_row(loc.table_i18n, loc.columns)
    detection_key = compute_detection_key(loc, finding, normalized_primary_keys)
    record: dict[str, Any] = {
        "detection_key": detection_key,
        "table_name": loc.table_i18n,
        "detected_version": detected_version,
        "column_id": col,
    }
    if loc.table_i18n in _PY_TABLES:
        record.update(_py_post_fields(loc.table_i18n, loc))
    else:
        record["table_org"] = loc.table_org
        record["schema_org"] = loc.schema_org

    # Flat row shape aligned with GET /api/i18n/messages (metadata + PK columns)
    for key, value in normalized_primary_keys.items():
        if _include_pk_field(loc.table_i18n, key):
            record[key] = value
    for key, value in loc.columns.items():
        if not _include_pk_field(loc.table_i18n, key):
            continue
        if key in record or key.endswith("_en_us") or key.startswith("old_"):
            continue
        record[key] = _normalize_cell_value(value)
    if finding.update_kind == UpdateKind.TEXT_CHANGED:
        record[col] = finding.original_text
        record[f"old_{col}"] = finding.previous_text or ""
    else:
        record[col] = finding.original_text
    return record


def group_records(findings: list[ExtractedString], detected_version: str) -> dict[str, list[dict[str, Any]]]:
    grouped = {"changed": [], "deleted": [], "new": []}
    for finding in findings:
        if finding.db_location is None:
            continue
        record = finding_to_record(finding, detected_version)
        if finding.update_kind == UpdateKind.TEXT_CHANGED:
            grouped["changed"].append(record)
        elif finding.update_kind == UpdateKind.DELETED:
            grouped["deleted"].append(record)
        elif finding.update_kind == UpdateKind.NEW:
            grouped["new"].append(record)

    return grouped

# endregion


# region JSON / feat / dbstyle extractors

def _extract_translatable_strings(data: Any) -> list[dict[str, Any]]:
    results: list[dict[str, Any]] = []

    def recurse(item: Any) -> None:
        if isinstance(item, dict):
            entry: dict[str, Any] = {}
            for key, value in item.items():
                if key in TRANSLATABLE_JSON_KEYS:
                    if key == "comboNames" and isinstance(value, list):
                        entry[key] = value
                    elif isinstance(value, str):
                        entry[key] = value
                recurse(value)
            if entry:
                results.append(entry)
        elif isinstance(item, list):
            for sub in item:
                recurse(sub)

    recurse(data)
    return results


def _json_column_for_table_org(table_org: str) -> str:
    if table_org == "config_report":
        return "filterparam"
    if table_org == "config_toolbox":
        return "inputparams"
    if table_org == "config_form_fields":
        return "widgetcontrols"
    return ""


_FEAT_FORM_RULES: tuple[tuple[str, str], ...] = (
    ("ARC", "ve_arc"),
    ("NODE", "ve_node"),
    ("CONNEC", "ve_connec"),
    ("GULLY", "ve_gully"),
    ("ELEMENT", "ve_element"),
    ("LINK", "ve_link"),
    ("FLWREG", "ve_flwreg"),
)


def _form_fields_feat_exclude_condition(column_prefix: str = "", negation: bool = True) -> str:
    prefix = f"{column_prefix}." if column_prefix else ""
    form_conditions = " OR ".join(
        f"({prefix}formname LIKE '{form_prefix}%%' OR {prefix}formname = '{form_prefix}')"
        for _, form_prefix in _FEAT_FORM_RULES
    )
    if negation:
        return f"NOT ({prefix}formtype = 'form_feature' AND ({form_conditions}))"
    else:
        return f"({prefix}formtype = 'form_feature' AND ({form_conditions}))"


def _append_sql_condition(query: str, condition: str) -> str:
    if " WHERE " in query.upper():
        return f"{query} AND {condition}"
    return f"{query} WHERE {condition}"


def _get_dbstyle_rows(rows_org: list[dict]) -> list[dict]:
    result = []
    for row in rows_org:
        stylevalue = row.get("stylevalue", "") or ""
        i = 1
        for line in stylevalue.split("\n"):
            m = _DBSTYLE_LABEL_RE.search(line)
            if m:
                new_row = dict(row)
                new_row["hint"] = f"label_{i}"
                new_row["lb_en_us"] = m.group(1)
                i += 1
                result.append(new_row)
    return result


def _filter_i18n_rows(
    all_rows: list[dict],
    table_name: str,
    project_type: str,
) -> list[dict]:
    return [
        row for row in all_rows
        if row.get("table_name", row.get("table_i18n", "")) in ("", table_name)
        and (not row.get("project_type") or row.get("project_type") == project_type)
    ]


def _filter_i18n_rows_by_context(rows: list[dict], table_org: str) -> list[dict]:
    """Keep baseline rows that belong to the current origin table (e.g. edit_typevalue)."""
    return [row for row in rows if str(row.get("context", "")) == table_org]


def _extract_json_table(
    origin: OriginDb,
    i18n_rows: list[dict],
    table_name: str,
    table_org: str,
    schema_org: str,
    project_type: str,
) -> list[ExtractedString]:
    column = _json_column_for_table_org(table_org)
    if not column:
        return []

    is_form_fields = table_name == "dbconfig_form_fields_json"
    if is_form_fields:
        pk_column_org = ["formname", "formtype", "tabname", "columnname"]
        columns_i18n = [
            "source_code", "project_type", "context", "formname", "formtype",
            "tabname", "source", "hint", "lb_en_us",
        ]
    else:
        pk_column_org = ["id"]
        columns_i18n = ["source_code", "project_type", "context", "hint", "source", "lb_en_us"]

    where_conditions = [
        f"""{column}::text ILIKE '%%{key}":%%'""" for key in TRANSLATABLE_JSON_KEYS
    ]
    where_clause = " OR ".join(where_conditions)
    query_org = (
        f"SELECT {', '.join(pk_column_org)}, {column} "
        f"FROM {schema_org}.{table_org} WHERE {where_clause}"
    )
    rows_org = origin.fetch_all(query_org)

    rows_i18n = _filter_i18n_rows_by_context(
        _clean_rows_i18n(
            _filter_i18n_rows(i18n_rows, table_name, project_type),
            columns_i18n,
            project_type,
            table_name,
        ),
        table_org,
    )

    expected: list[dict] = []
    for row in rows_org:
        payload = row.get(column)
        if payload in (None, "", "None"):
            continue
        datas = _extract_translatable_strings(payload)
        for i, data in enumerate(datas):
            for key, text in data.items():
                if isinstance(text, list):
                    text_val = ", ".join(str(t) for t in text)
                elif isinstance(text, str):
                    text_val = text
                else:
                    continue
                hint = f"{key}_{i}"
                if is_form_fields:
                    expected.append({
                        "source_code": "giswater",
                        "project_type": project_type,
                        "context": table_org,
                        "formname": row["formname"],
                        "formtype": row["formtype"],
                        "tabname": row["tabname"],
                        "source": row["columnname"],
                        "hint": hint,
                        "lb_en_us": text_val,
                    })
                else:
                    expected.append({
                        "source_code": "giswater",
                        "project_type": project_type,
                        "context": table_org,
                        "hint": hint,
                        "source": row["id"],
                        "lb_en_us": text_val,
                    })

    return _compare_db_rows(
        expected,
        rows_i18n,
        columns_i18n,
        table_name=table_name,
        table_org=table_org,
        schema_org=schema_org,
        project_type=project_type,
    )


def _extract_feat_table(
    origin: OriginDb,
    i18n_rows: list[dict],
    table_name: str,
    schema_org: str,
    project_type: str,
) -> list[ExtractedString]:
    pk_column_org = ["formname", "formtype", "tabname", "columnname"]
    columns_org = ["label", "tooltip"]
    columns_i18n = [
        "feature_type", "source_code", "project_type", "context",
        "formtype", "tabname", "source", "lb_en_us", "tt_en_us",
    ]

    query_org = f"SELECT {', '.join(pk_column_org)}, {', '.join(columns_org)} FROM {schema_org}.config_form_fields"
    query_org = _append_sql_condition(
                        query_org, _form_fields_feat_exclude_condition(negation=False)
                    )
    rows_org = origin.fetch_all(query_org)

    rows_i18n = _filter_i18n_rows_by_context(
        _clean_rows_i18n(
            _filter_i18n_rows(i18n_rows, table_name, project_type),
            columns_i18n,
            project_type,
            table_name,
        ),
        "config_form_fields",
    )

    expected: list[dict] = []
    for feature_type, prefix in _FEAT_FORM_RULES:
        repeated_rows: list[tuple[str, str, str]] = []
        for row in rows_org:
            formname = str(row.get("formname", ""))
            if row.get("formtype") != "form_feature":
                continue
            if not (formname.startswith(prefix) or formname == prefix):
                continue
            repeated_row = (row.get("formtype"),  row.get("tabname"), row.get("columnname"))
            if repeated_row in repeated_rows:
                continue
            expected.append({
                "feature_type": feature_type,
                "source_code": "giswater",
                "project_type": project_type,
                "context": "config_form_fields",
                "formtype": row.get("formtype", ""),
                "tabname": row.get("tabname", ""),
                "source": row.get("columnname", ""),
                "lb_en_us": row.get("label", "") or "",
                "tt_en_us": row.get("tooltip", "") or "",
            })
            repeated_rows.append(repeated_row)

    return _compare_db_rows(
        expected,
        rows_i18n,
        columns_i18n,
        table_name=table_name,
        table_org="config_form_fields",
        schema_org=schema_org,
        project_type=project_type,
    )


def _extract_dbstyle_table(
    origin: OriginDb,
    i18n_rows: list[dict],
    table_name: str,
    table_org: str,
    schema_org: str,
    project_type: str,
) -> list[ExtractedString]:
    columns_i18n_raw, columns_org = get_columns_to_compare(table_name, table_org, project_type)
    columns_i18n = _normalize_i18n_columns(columns_i18n_raw)

    rows_i18n = _filter_i18n_rows_by_context(
        _clean_rows_i18n(
            _filter_i18n_rows(i18n_rows, table_name, project_type),
            columns_i18n,
            project_type,
            table_name,
        ),
        table_org,
    )

    query_org = f"SELECT {', '.join(columns_org)} FROM {schema_org}.{table_org}"
    rows_org = _get_dbstyle_rows(origin.fetch_all(query_org))
    columns_org_compare = list(columns_org)
    if "hint" not in columns_org_compare:
        columns_org_compare.extend(["hint", "lb_en_us"])
    rows_org = _clean_rows_org(rows_org, columns_org_compare, project_type, table_org)
    aligned_org = _align_org_rows(
        rows_org, columns_org_compare, columns_i18n, project_type, table_org, is_dbstyle=True
    )

    return _compare_db_rows(
        aligned_org,
        rows_i18n,
        columns_i18n,
        table_name=table_name,
        table_org=table_org,
        schema_org=schema_org,
        project_type=project_type,
    )


def extract_db_candidates(
    origin: OriginDb,
    i18n_rows: list[dict],
    config: SearcherConfig,
) -> list[ExtractedString]:
    findings: list[ExtractedString] = []

    for project_type in config.project_types:
        tables_i18n, sutables = tables_dic(project_type)
        if config.include_su_tables:
            tables_i18n.extend(table for table in sutables if table not in tables_i18n)

        schema_org = config.origin_schemas.get(project_type)
        if not schema_org:
            continue

        if not origin.schema_exists(schema_org):
            log.warning("Origin schema %s does not exist", schema_org)
            continue
        if not origin.verify_lang(schema_org):
            log.warning("Origin schema %s language is not en_US/no_TR", schema_org)
            continue

        for table_name in tables_i18n:
            table_i18n_rows = _filter_i18n_rows(i18n_rows, table_name, project_type)

            for table_org in find_table_org_with_context(table_i18n_rows, table_name, project_type):
                if not origin.table_exists(schema_org, table_org):
                    continue

                if table_name.startswith("su_"):
                    continue

                if table_name == "dbconfig_form_fields_feat":
                    findings.extend(
                        _extract_feat_table(origin, table_i18n_rows, table_name, schema_org, project_type)
                    )
                    continue
                if "json" in table_name:
                    findings.extend(
                        _extract_json_table(
                            origin, table_i18n_rows, table_name, table_org, schema_org, project_type
                        )
                    )
                    continue
                if table_name == "dbstyle":
                    findings.extend(
                        _extract_dbstyle_table(
                            origin, table_i18n_rows, table_name, table_org, schema_org, project_type
                        )
                    )
                    continue

                columns_i18n_raw, columns_org = get_columns_to_compare(
                    table_name, table_org, project_type
                )
                columns_i18n = _normalize_i18n_columns(columns_i18n_raw)

                rows_i18n = _filter_i18n_rows_by_context(
                    _clean_rows_i18n(table_i18n_rows, columns_i18n, project_type, table_name),
                    table_org,
                )

                cols_org_sql = ", ".join(columns_org)
                query_org = f"SELECT {cols_org_sql} FROM {schema_org}.{table_org}"
                if table_name == "dbconfig_form_fields":
                    query_org = _append_sql_condition(
                        query_org, _form_fields_feat_exclude_condition(negation=True)
                    )
                rows_org = origin.fetch_all(query_org)

                rows_org = _clean_rows_org(rows_org, columns_org, project_type, table_org)
                aligned_org = _align_org_rows(
                    rows_org, columns_org, columns_i18n, project_type, table_org, is_dbstyle=False
                )

                findings.extend(
                    _compare_db_rows(
                        aligned_org,
                        rows_i18n,
                        columns_i18n,
                        table_name=table_name,
                        table_org=table_org,
                        schema_org=schema_org,
                        project_type=project_type,
                    )
                )

    log.info("DB extraction: %d detection(s)", len(findings))
    return findings

# endregion


# region CLI

def _parse_origin_schemas(raw: str | None, project_types: list[str]) -> dict[str, str]:
    defaults = {"ws": "ws_trans", "ud": "ud_trans", "cm": "cm", "am": "am"}
    if not raw:
        return {pt: defaults[pt] for pt in project_types if pt in defaults}
    result: dict[str, str] = {}
    for part in raw.split(","):
        part = part.strip()
        if not part:
            continue
        if "=" not in part:
            raise ValueError(f"Invalid origin schema mapping: {part!r} (expected project=schema)")
        project, schema = part.split("=", 1)
        result[project.strip()] = schema.strip()
    return result


def _resolve_detected_version(
    origin: OriginDb,
    origin_schemas: dict[str, str],
    cli_version: str,
) -> str:
    for schema in origin_schemas.values():
        version = origin.schema_version(schema)
        if version:
            return version
    return cli_version


def _read_metadata_version(repo_root: Path) -> str:
    metadata = repo_root / "metadata.txt"
    if not metadata.is_file():
        return ""
    for line in metadata.read_text(encoding="utf-8").splitlines():
        if line.startswith("version="):
            return line.split("=", 1)[1].strip()
    return ""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Detect i18n text changes and upload to the translations API.",
    )
    parser.add_argument("--base-url", default=None, help="Translations API base URL")
    parser.add_argument("--user", default=None, help="API username")
    parser.add_argument("--password", default=None, help="API password")
    parser.add_argument(
        "--messages-path",
        default=None,
        help=f"GET path for i18n baseline (default: {DEFAULT_MESSAGES_PATH})",
    )
    parser.add_argument(
        "--changed-path",
        default=None,
        help=f"POST path for changed texts (default: {DEFAULT_CHANGED_PATH})",
    )
    parser.add_argument(
        "--deleted-path",
        default=None,
        help=f"POST path for deleted texts (default: {DEFAULT_DELETED_PATH})",
    )
    parser.add_argument(
        "--new-path",
        default=None,
        help=f"POST path for new texts (default: {DEFAULT_NEW_PATH})",
    )
    parser.add_argument(
        "--origin-conn",
        default=None,
        help="PostgreSQL connection string for origin schemas (env: ORIGIN_PG_CONN or GW_CONN)",
    )
    parser.add_argument(
        "--project-types",
        default="ws,ud",
        help="Comma-separated project types to scan (default: ws,ud)",
    )
    parser.add_argument(
        "--origin-schemas",
        default=None,
        help="Comma-separated project=schema mappings (default: ws=ws_trans,ud=ud_trans,...)",
    )
    parser.add_argument(
        "--version",
        default=None,
        help="Detected version fallback (default: origin sys_version or metadata.txt)",
    )
    parser.add_argument(
        "--repo-root",
        default=".",
        help="Plugin repository root (default: current directory)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Classify and print counts without POSTing detections",
    )
    parser.add_argument(
        "--json-out",
        default=None,
        help="Optional path to write grouped detection records as JSON",
    )
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable debug logging")
    return parser.parse_args()


def _upload_grouped_records(
    api: TranslationsApiClient,
    grouped: dict[str, list[dict[str, Any]]],
    *,
    new_path: str,
    changed_path: str,
    deleted_path: str,
    dry_run: bool,
) -> None:
    for kind, path in (
        ("new", new_path),
        ("changed", changed_path),
        ("deleted", deleted_path),
    ):
        upload_detection_records(api, path, grouped[kind], dry_run=dry_run, kind=kind)


def main() -> int:
    args = parse_args()
    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(levelname)s: %(message)s",
    )

    base_url = (resolve_setting(args.base_url, "TRANSLATIONS_API_URL") or "").strip()
    user = (resolve_setting(args.user, "TRANSLATIONS_API_USER", "") or "").strip()
    password = (resolve_setting(args.password, "TRANSLATIONS_API_PASSWORD", "") or "").strip()
    origin_conn = (
        resolve_setting(args.origin_conn, "ORIGIN_PG_CONN")
        or resolve_setting(None, "GW_CONN")
        or ""
    ).strip()

    if not base_url:
        print("Error: missing API base URL. Set TRANSLATIONS_API_URL or pass --base-url.", file=sys.stderr)
        return 1
    if not origin_conn:
        print(
            "Error: missing origin DB connection. Set ORIGIN_PG_CONN/GW_CONN or pass --origin-conn.",
            file=sys.stderr,
        )
        return 1

    project_types = [p.strip() for p in args.project_types.split(",") if p.strip()]
    origin_schemas = _parse_origin_schemas(args.origin_schemas, project_types)
    repo_root = Path(args.repo_root).resolve()

    messages_path = resolve_setting(args.messages_path, "I18N_MESSAGES_PATH", DEFAULT_MESSAGES_PATH)
    changed_path = resolve_setting(args.changed_path, "I18N_CHANGED_PATH", DEFAULT_CHANGED_PATH)
    deleted_path = resolve_setting(args.deleted_path, "I18N_DELETED_PATH", DEFAULT_DELETED_PATH)
    new_path = resolve_setting(args.new_path, "I18N_NEW_PATH", DEFAULT_NEW_PATH)

    config = SearcherConfig(
        repo_root=repo_root,
        project_types=project_types,
        origin_schemas=origin_schemas,
        dry_run=args.dry_run,
    )

    origin = OriginDb(origin_conn)
    try:
        cli_version = (args.version or _read_metadata_version(repo_root) or "").strip()
        detected_version = _resolve_detected_version(origin, origin_schemas, cli_version)
        if not detected_version:
            print("Error: could not resolve detected_version.", file=sys.stderr)
            return 1
        log.info("Detected version: %s", detected_version)

        with TranslationsApiClient(base_url, user, password) as api:
            log.info("Fetching full i18n baseline from %s (no query filters)", messages_path)
            i18n_rows = fetch_i18n_messages(api, messages_path or DEFAULT_MESSAGES_PATH)
            log.info("Loaded %d i18n row(s) from API; filtering by table/project in memory", len(i18n_rows))

            findings_db = extract_db_candidates(origin, i18n_rows, config)
            findings_py = extract_py_candidates(i18n_rows, config)
            findings = findings_db + findings_py
            grouped = group_records(findings, detected_version)

            if args.json_out:
                out_path = Path(args.json_out)
                out_path.parent.mkdir(parents=True, exist_ok=True)
                out_path.write_text(
                    json.dumps(grouped, ensure_ascii=False, indent=2) + "\n",
                    encoding="utf-8",
                )
                log.info("Wrote %s", out_path)

            print(
                "Detections (unique records to POST): "
                f"{len(grouped['new'])} new, "
                f"{len(grouped['changed'])} changed, "
                f"{len(grouped['deleted'])} deleted"
            )

            _upload_grouped_records(
                api,
                grouped,
                new_path=new_path or DEFAULT_NEW_PATH,
                changed_path=changed_path or DEFAULT_CHANGED_PATH,
                deleted_path=deleted_path or DEFAULT_DELETED_PATH,
                dry_run=config.dry_run,
            )

        return 0
    except (RuntimeError, ValueError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1
    finally:
        origin.close()


if __name__ == "__main__":
    raise SystemExit(main())

# endregion
