"""
Parse bundled i18n baseline SQL (UPDATE … FROM (VALUES …)) and build
INSERT statements for the multilang satellite schema.

Initial scope: en_US only; baselines are loaded per project_type (ws, ud, am, cm).
"""

from __future__ import annotations

import hashlib
import json
import os
import re
from dataclasses import dataclass, field
from typing import Any, Callable, Iterable, Optional, Sequence

# Hardcoded initial language scope.
SEED_LANGUAGE_ID = "en_us"
SEED_LANGUAGE_FOLDER = "en_US"

# Relative dbmodel paths to bundled baseline SQL (language folder appended).
_I18N_BASELINE_ROOTS: dict[str, str] = {
    "ws": os.path.join("schemas", "main", "ws", "final_pass", "i18n"),
    "ud": os.path.join("schemas", "main", "ud", "final_pass", "i18n"),
    "am": os.path.join("schemas", "addon", "am", "final_pass", "i18n"),
    "cm": os.path.join("schemas", "addon", "cm", "final_pass", "i18n"),
}

TRANSLATABLE_PROJECT_TYPES: frozenset[str] = frozenset(_I18N_BASELINE_ROOTS.keys())

# Baseline SQL file stem -> multilang schema table (mains_language_ui.md scope).
BASELINE_TO_MULTILANG_TABLE: dict[str, str] = {
    "dbconfig_form_fields": "config_form_fields",
    "dbconfig_form_fields_feat": "config_form_fields",
    "dbconfig_form_fields_json": "config_form_fields_json",
    "dbtable": "sys_table",
    "dbmessage": "sys_message",
    "dbfunction": "sys_function",
    "dbfprocess": "sys_fprocess",
    "dbparam_user": "sys_param_user",
    "dbconfig_form_tabs": "config_form_tabs",
    "dbconfig_param_system": "config_param_system",
}

MULTILANG_UI_TABLES: tuple[str, ...] = tuple(sorted(set(BASELINE_TO_MULTILANG_TABLE.values())))

_CORE_BASELINE_FILES: tuple[str, ...] = tuple(BASELINE_TO_MULTILANG_TABLE.keys())

# Baseline SQL files per project type (skip missing files at load time).
_PROJECT_TYPE_TABLES: dict[str, tuple[str, ...]] = {
    "ws": _CORE_BASELINE_FILES,
    "ud": _CORE_BASELINE_FILES,
    "am": (),
    "cm": (
        "dbconfig_form_fields",
        "dbconfig_form_fields_json",
        "dbconfig_form_tabs",
        "dbconfig_param_system",
        "dbfprocess",
        "dbtable",
    ),
}

# Backward-compatible default used by older callers/tests (WS bundle).
SEED_TABLE_FILES: tuple[str, ...] = _PROJECT_TYPE_TABLES["ws"]

UPDATE_HEADER_RE = re.compile(
    r"UPDATE\s+(?P<context>\w+)\s+AS\s+t\s+SET\s+(?P<set_clause>.+?)\s+FROM\s*\(\s*VALUES\s*",
    re.IGNORECASE | re.DOTALL,
)

SET_ASSIGN_RE = re.compile(
    r"(?P<target>\w+)\s*=\s*(?:REPLACE\s*\(\s*)?v\.(?P<alias>\w+)",
    re.IGNORECASE,
)

_ORG_TO_I18N_DEFAULT = {
    "alias": "al",
    "descript": "ds",
    "label": "lb",
    "tooltip": "tt",
    "idval": "vl",
    "error_message": "ms",
    "hint_message": "ht",
    "except_msg": "ex",
    "info_msg": "in",
    "fprocess_name": "na",
    "observ": "ob",
    "widgetcontrols": "text",
    "filterparam": "text",
    "inputparams": "text",
    "text": "tx",
    "price": "pr",
    "name": "na",
    "value": "vl",
}

# Context-specific org column -> multilang column overrides.
_CONTEXT_I18N_OVERRIDES: dict[str, dict[str, str]] = {
    "config_typevalue": {"idval": "tt"},
    "sys_param_user": {"descript": "tt"},
    "config_param_system": {"descript": "tt"},
}

# ON CONFLICT target columns per multilang table (must match DDL PK).
_TABLE_CONFLICT_KEYS: dict[str, tuple[str, ...]] = {
    "config_form_fields": ("tabname", "context", "formname", "formtype", "schema_name", "source", "lang"),
    "config_form_fields_json": (
        "tabname", "context", "formname", "formtype", "schema_name", "source", "hint", "lang",
    ),
    "config_form_tabs": ("schema_name", "context", "formname", "source", "lang"),
    "config_param_system": ("schema_name", "context", "source", "lang"),
    "sys_fprocess": ("schema_name", "context", "source", "lang"),
    "sys_function": ("schema_name", "context", "source", "lang"),
    "sys_message": ("schema_name", "context", "source", "lang"),
    "sys_param_user": ("schema_name", "context", "source", "lang"),
    "sys_table": ("schema_name", "context", "source", "lang"),
}

# Multilang columns that must be double-quoted in generated SQL.
_QUOTED_SQL_COLUMNS = frozenset({"source", "in", "text", "parameter", "method"})


def _quote_sql_col(name: str) -> str:
    if name in _QUOTED_SQL_COLUMNS:
        return f'"{name}"'
    return name


def _dedupe_rows_by_conflict_key(
    table: str,
    rows: Sequence[MultilangRow],
) -> list[MultilangRow]:
    """Keep one row per ON CONFLICT target; later baseline rows win."""
    conflict_keys = _TABLE_CONFLICT_KEYS.get(table)
    if not conflict_keys or not rows:
        return list(rows)

    deduped: dict[tuple[Any, ...], MultilangRow] = {}
    for row in rows:
        key = tuple(row.values.get(col) for col in conflict_keys)
        deduped[key] = row
    return list(deduped.values())


@dataclass
class ParsedUpdateBlock:
    context: str
    set_targets: dict[str, str]  # org column -> v alias
    value_aliases: list[str]
    rows: list[list[Any]] = field(default_factory=list)
    json_hints: list[str] = field(default_factory=list)  # SET targets stored as hint (json cols)


@dataclass
class MultilangRow:
    table: str
    values: dict[str, Any]


def baseline_i18n_dir(
    sql_root: str,
    project_type: str,
    *,
    lang: str = SEED_LANGUAGE_FOLDER,
) -> str | None:
    """Return bundled baseline i18n folder for a project type, or None if unsupported."""
    pt = normalize_project_type(project_type)
    if not pt:
        return None
    rel = _I18N_BASELINE_ROOTS.get(pt)
    if not rel:
        return None
    return os.path.join(sql_root, rel, lang)


def normalize_project_type(project_type: str | None) -> str | None:
    if not project_type:
        return None
    key = str(project_type).strip().lower()
    if key in TRANSLATABLE_PROJECT_TYPES:
        return key
    return None


def project_type_has_baseline(
    sql_root: str,
    project_type: str,
    *,
    lang: str = SEED_LANGUAGE_FOLDER,
) -> bool:
    i18n_dir = baseline_i18n_dir(sql_root, project_type, lang=lang)
    if not i18n_dir or not os.path.isdir(i18n_dir):
        return False
    return any(name.endswith(".sql") for name in os.listdir(i18n_dir))


def seed_table_files_for_project_type(
    project_type: str,
    sql_root: str,
    *,
    lang: str = SEED_LANGUAGE_FOLDER,
) -> tuple[str, ...]:
    """Baseline table files to import for one project type (existing files only)."""
    pt = normalize_project_type(project_type)
    if not pt:
        return ()

    i18n_dir = baseline_i18n_dir(sql_root, pt, lang=lang)
    if not i18n_dir or not os.path.isdir(i18n_dir):
        return ()

    tables: list[str] = []
    for baseline_file in _PROJECT_TYPE_TABLES.get(pt, ()):
        target = BASELINE_TO_MULTILANG_TABLE.get(baseline_file)
        if not target or target not in _TABLE_CONFLICT_KEYS:
            continue
        if os.path.isfile(os.path.join(i18n_dir, f"{baseline_file}.sql")):
            tables.append(baseline_file)
    return tuple(tables)


def parse_sql_value_tuple(raw: str) -> list[Any]:
    """Parse one SQL VALUES tuple: (a, 'b', NULL, 1)."""
    text = raw.strip()
    if not text.startswith("(") or not text.endswith(")"):
        raise ValueError(f"Invalid tuple: {raw[:80]!r}")
    inner = text[1:-1]
    values: list[Any] = []
    i = 0
    length = len(inner)

    while i < length:
        while i < length and inner[i] in " \t\n\r,":
            i += 1
        if i >= length:
            break

        if inner[i] == "'":
            i += 1
            chars: list[str] = []
            while i < length:
                ch = inner[i]
                if ch == "'":
                    if i + 1 < length and inner[i + 1] == "'":
                        chars.append("'")
                        i += 2
                        continue
                    i += 1
                    break
                chars.append(ch)
                i += 1
            values.append("".join(chars))
            continue

        if inner[i:].upper().startswith("NULL"):
            values.append(None)
            i += 4
            continue

        start = i
        while i < length and inner[i] not in ",)":
            i += 1
        token = inner[start:i].strip()
        if not token:
            continue
        if re.fullmatch(r"-?\d+", token):
            values.append(int(token))
        elif re.fullmatch(r"-?\d+\.\d+", token):
            values.append(float(token))
        else:
            values.append(token)

    return values


def split_value_tuples(values_blob: str) -> list[str]:
    """Split VALUES blob into individual tuple strings."""
    tuples: list[str] = []
    depth = 0
    start: int | None = None
    in_quote = False
    idx = 0
    length = len(values_blob)

    while idx < length:
        ch = values_blob[idx]
        if ch == "'":
            if not in_quote:
                in_quote = True
            elif idx + 1 < length and values_blob[idx + 1] == "'":
                idx += 1
            else:
                in_quote = False
            idx += 1
            continue

        if in_quote:
            idx += 1
            continue

        if ch == "(":
            if depth == 0:
                start = idx
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth == 0 and start is not None:
                tuples.append(values_blob[start: idx + 1])
                start = None
        idx += 1

    return tuples


def _parse_single_update_chunk(chunk: str) -> ParsedUpdateBlock | None:
    header = UPDATE_HEADER_RE.match(chunk)
    if not header:
        return None

    values_start = header.end()
    alias_marker = ") AS v("
    alias_pos = chunk.find(alias_marker, values_start)
    if alias_pos == -1:
        return None

    values_blob = chunk[values_start:alias_pos]
    alias_close = chunk.find(")", alias_pos + len(alias_marker))
    if alias_close == -1:
        return None

    aliases = [
        part.strip()
        for part in chunk[alias_pos + len(alias_marker): alias_close].split(",")
        if part.strip()
    ]
    context = header.group("context")
    set_clause = header.group("set_clause")

    set_targets: dict[str, str] = {}
    json_hints: list[str] = []
    for set_match in SET_ASSIGN_RE.finditer(set_clause):
        target = set_match.group("target")
        alias = set_match.group("alias")
        set_targets[target] = alias
        if target in ("widgetcontrols", "filterparam", "inputparams"):
            json_hints.append(target)

    rows: list[list[Any]] = []
    for tuple_raw in split_value_tuples(values_blob):
        try:
            rows.append(parse_sql_value_tuple(tuple_raw))
        except ValueError:
            continue

    if not rows:
        return None

    return ParsedUpdateBlock(
        context=context,
        set_targets=set_targets,
        value_aliases=aliases,
        rows=rows,
        json_hints=json_hints,
    )


def parse_update_blocks(sql_text: str) -> list[ParsedUpdateBlock]:
    blocks: list[ParsedUpdateBlock] = []
    search_from = 0
    marker = "UPDATE "

    while True:
        idx = sql_text.find(marker, search_from)
        if idx == -1:
            break
        next_idx = sql_text.find(marker, idx + len(marker))
        chunk = sql_text[idx: next_idx if next_idx != -1 else len(sql_text)]
        block = _parse_single_update_chunk(chunk)
        if block is not None:
            blocks.append(block)
        search_from = idx + len(marker)

    return blocks


def _alias_index(aliases: Sequence[str], name: str) -> int | None:
    try:
        return aliases.index(name)
    except ValueError:
        lowered = name.lower()
        for idx, alias in enumerate(aliases):
            if alias.lower() == lowered:
                return idx
    return None


def _cell(row: Sequence[Any], aliases: Sequence[str], alias: str) -> Any:
    idx = _alias_index(aliases, alias)
    if idx is None or idx >= len(row):
        return None
    return row[idx]


def _org_to_i18n(context: str, org_column: str) -> str | None:
    overrides = _CONTEXT_I18N_OVERRIDES.get(context, {})
    if org_column in overrides:
        return overrides[org_column]
    return _ORG_TO_I18N_DEFAULT.get(org_column)


def _sql_literal(value: Any, *, as_json: bool = False) -> str:
    if value is None:
        return "NULL"
    text = str(value).replace("'", "''")
    if as_json:
        return f"'{text}'::json"
    return f"'{text}'"


def blocks_to_multilang_rows(
    table: str,
    blocks: Iterable[ParsedUpdateBlock],
    *,
    schema_name: str,
    lang: str = SEED_LANGUAGE_ID,
) -> list[MultilangRow]:
    rows: list[MultilangRow] = []
    for block in blocks:
        for raw in block.rows:
            values: dict[str, Any] = {
                "schema_name": schema_name,
                "context": block.context,
                "lang": lang,
            }

            if table == "dbconfig_form_fields":
                values.update({
                    "source": _cell(raw, block.value_aliases, "columnname"),
                    "formname": _cell(raw, block.value_aliases, "formname"),
                    "formtype": _cell(raw, block.value_aliases, "formtype"),
                    "tabname": _cell(raw, block.value_aliases, "tabname"),
                })
            elif table == "dbconfig_form_fields_feat":
                values.update({
                    "source": _cell(raw, block.value_aliases, "columnname"),
                    "formname": _cell(raw, block.value_aliases, "formname"),
                    "formtype": _cell(raw, block.value_aliases, "formtype"),
                    "tabname": _cell(raw, block.value_aliases, "tabname"),
                })
            elif table == "dbconfig_form_fields_json":
                values.update({
                    "source": _cell(raw, block.value_aliases, "columnname"),
                    "formname": _cell(raw, block.value_aliases, "formname"),
                    "formtype": _cell(raw, block.value_aliases, "formtype"),
                    "tabname": _cell(raw, block.value_aliases, "tabname"),
                    "hint": block.json_hints[0] if block.json_hints else "widgetcontrols",
                    "text": _cell(raw, block.value_aliases, "text"),
                })
            elif table == "dbconfig_form_tabs":
                values.update({
                    "formname": _cell(raw, block.value_aliases, "formname"),
                    "source": _cell(raw, block.value_aliases, "tabname"),
                })
            elif table == "dbconfig_form_tableview":
                values.update({
                    "source": _cell(raw, block.value_aliases, "objectname"),
                    "columnname": _cell(raw, block.value_aliases, "columnname"),
                })
            elif table == "dbconfig_typevalue":
                values.update({
                    "formname": _cell(raw, block.value_aliases, "formname"),
                    "source": _cell(raw, block.value_aliases, "source"),
                })
            elif table == "dbtypevalue":
                values.update({
                    "source": _cell(raw, block.value_aliases, "id"),
                    "typevalue": _cell(raw, block.value_aliases, "typevalue"),
                })
            elif table == "dbconfig_param_system":
                values["source"] = _cell(raw, block.value_aliases, "parameter")
            elif table in ("dbparam_user", "dbmessage", "dbfprocess", "dbconfig_report",
                           "dbconfig_toolbox", "dbfunction", "dbtable", "dbconfig_visit_parameter"):
                key = "fid" if table == "dbfprocess" else "id"
                values["source"] = _cell(raw, block.value_aliases, key)
            elif table == "dbconfig_csv":
                values["source"] = _cell(raw, block.value_aliases, "fid")
            elif table == "dblabel":
                values["source"] = _cell(raw, block.value_aliases, "id")
            elif table == "dbplan_price":
                values["source"] = _cell(raw, block.value_aliases, "id")
            elif table == "dbjson":
                hint = block.json_hints[0] if block.json_hints else next(iter(block.set_targets), "text")
                values.update({
                    "hint": hint,
                    "source": _cell(raw, block.value_aliases, "id"),
                    "text": _cell(raw, block.value_aliases, "text"),
                })
            else:
                continue

            for org_col, v_alias in block.set_targets.items():
                i18n_col = _org_to_i18n(block.context, org_col)
                if not i18n_col:
                    continue
                if table == "dbconfig_form_fields_json" and i18n_col == "text":
                    values["text"] = _cell(raw, block.value_aliases, v_alias)
                elif table == "dbjson" and i18n_col == "text":
                    values["text"] = _cell(raw, block.value_aliases, v_alias)
                else:
                    values[i18n_col] = _cell(raw, block.value_aliases, v_alias)

            if values.get("source") is not None:
                values["source"] = str(values["source"])

            target_table = BASELINE_TO_MULTILANG_TABLE.get(table)
            if not target_table:
                continue
            rows.append(MultilangRow(table=target_table, values=values))
    return rows


def build_insert_sql(table: str, rows: Sequence[MultilangRow], *, batch_size: int = 200) -> list[str]:
    rows = _dedupe_rows_by_conflict_key(table, rows)
    if not rows:
        return []

    conflict_keys = _TABLE_CONFLICT_KEYS.get(table)
    if not conflict_keys:
        return []

    statements: list[str] = []
    for start in range(0, len(rows), batch_size):
        chunk = rows[start: start + batch_size]
        columns = list(chunk[0].values.keys())
        update_cols = [
            col for col in columns
            if col not in conflict_keys and col not in ("schema_name", "context", "lang")
        ]

        values_sql: list[str] = []
        for row in chunk:
            literals = []
            for col in columns:
                val = row.values.get(col)
                as_json = col == "text" and table in ("dbjson", "config_form_fields_json")
                literals.append(_sql_literal(val, as_json=as_json))
            values_sql.append(f"({', '.join(literals)})")

        conflict = ", ".join(_quote_sql_col(key) for key in conflict_keys)
        quoted_columns = ", ".join(_quote_sql_col(col) for col in columns)
        update_clause = ", ".join(
            f"{_quote_sql_col(col)} = EXCLUDED.{_quote_sql_col(col)}"
            for col in update_cols
        )
        sql = (
            f"INSERT INTO multilang.{table} ({quoted_columns}) "
            f"VALUES {', '.join(values_sql)} "
            f"ON CONFLICT ({conflict}) DO UPDATE SET {update_clause};"
        )
        statements.append(sql)
    return statements


def load_baseline_rows(
    sql_root: str,
    *,
    schema_name: str,
    project_type: str,
    lang: str = SEED_LANGUAGE_ID,
) -> list[MultilangRow]:
    """Load and convert baseline files for one schema and its project type."""
    pt = normalize_project_type(project_type)
    if not pt or not project_type_has_baseline(sql_root, pt):
        return []

    i18n_dir = baseline_i18n_dir(sql_root, pt)
    if not i18n_dir:
        return []

    all_rows: list[MultilangRow] = []
    for baseline_file in seed_table_files_for_project_type(pt, sql_root):
        path = os.path.join(i18n_dir, f"{baseline_file}.sql")
        with open(path, encoding="utf-8") as handle:
            sql_text = handle.read()
        blocks = parse_update_blocks(sql_text)
        all_rows.extend(
            blocks_to_multilang_rows(
                baseline_file,
                blocks,
                schema_name=schema_name,
                lang=lang,
            )
        )
    return all_rows


def seed_sql_for_schema(
    sql_root: str,
    schema_name: str,
    *,
    project_type: str,
    lang: str = SEED_LANGUAGE_ID,
) -> list[str]:
    pt = normalize_project_type(project_type)
    if not pt or not project_type_has_baseline(sql_root, pt):
        return []

    rows = load_baseline_rows(
        sql_root,
        schema_name=schema_name,
        project_type=pt,
        lang=lang,
    )
    by_table: dict[str, list[MultilangRow]] = {}
    for row in rows:
        by_table.setdefault(row.table, []).append(row)

    statements: list[str] = []
    for target_table in MULTILANG_UI_TABLES:
        table_rows = by_table.get(target_table) or []
        statements.extend(build_insert_sql(target_table, table_rows))
    return statements


def compute_baseline_fingerprint(sql_root: str) -> str:
    """Fingerprint of bundled en_US baseline SQL files (content + mtime)."""
    digest = hashlib.sha256()
    for pt in sorted(TRANSLATABLE_PROJECT_TYPES):
        table_files = seed_table_files_for_project_type(pt, sql_root)
        if not table_files:
            continue
        digest.update(pt.encode("utf-8"))
        i18n_dir = baseline_i18n_dir(sql_root, pt)
        if not i18n_dir:
            continue
        for baseline_file in table_files:
            path = os.path.join(i18n_dir, f"{baseline_file}.sql")
            digest.update(baseline_file.encode("utf-8"))
            digest.update(str(os.path.getmtime(path)).encode("utf-8"))
            with open(path, "rb") as handle:
                for chunk in iter(lambda: handle.read(65536), b""):
                    digest.update(chunk)
    return digest.hexdigest()


def baseline_needs_reseed(sql_root: str, stored_fingerprint: str | None) -> bool:
    if not stored_fingerprint:
        return True
    return compute_baseline_fingerprint(sql_root) != stored_fingerprint


MULTILANG_SEED_TABLES: tuple[str, ...] = MULTILANG_UI_TABLES


def parse_stored_seeded_schemas(addparam: Any) -> set[str]:
    """Read seeded schema names from multilang.sys_version.addparam."""
    if not addparam:
        return set()
    try:
        data = json.loads(addparam) if isinstance(addparam, str) else addparam
    except (TypeError, ValueError):
        return set()
    if not isinstance(data, dict):
        return set()
    raw = data.get("seeded_schemas") or []
    if not isinstance(raw, list):
        return set()
    return {str(name) for name in raw if name}


def fetch_seeded_schema_names_from_multilang(
    fetcher: Callable[[str, Optional[list]], Optional[list[tuple]]],
) -> set[str]:
    """Return schema names that currently have rows in multilang seed tables."""
    names: set[str] = set()
    for table in MULTILANG_UI_TABLES:
        rows = fetcher(
            f"SELECT DISTINCT schema_name FROM multilang.{table} "
            "WHERE schema_name IS NOT NULL AND BTRIM(schema_name) <> ''",
            None,
        )
        if rows:
            names.update(str(row[0]) for row in rows if row and row[0])
    return names


def delete_schema_seed_sql(schema_names: Iterable[str]) -> list[str]:
    """Build DELETE statements for removed network schemas."""
    statements: list[str] = []
    for schema_name in schema_names:
        esc = str(schema_name).replace("'", "''")
        for table in MULTILANG_SEED_TABLES:
            statements.append(
                f"DELETE FROM multilang.{table} WHERE schema_name = '{esc}';"
            )
    return statements
