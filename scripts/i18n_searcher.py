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
import hashlib
import json
import logging
import re
import sys
from dataclasses import dataclass, field
from enum import Enum
from itertools import product
from pathlib import Path
from typing import Any, Optional

_SCRIPT_DIR = Path(__file__).resolve().parent
if str(_SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(_SCRIPT_DIR))

import psycopg2
import psycopg2.extras

from i18n_api_client import (
    DEFAULT_CHANGED_PATH,
    DEFAULT_DELETED_PATH,
    DEFAULT_MESSAGES_PATH,
    DEFAULT_NEW_PATH,
    TranslationsApiClient,
    fetch_i18n_messages,
    resolve_setting,
    upload_detection_records,
)

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

_QUOTED_SEGMENTS_RE = re.compile(r"(['\"])(.*?)\1")
_TAG_TEXT_RE = re.compile(r">(.*?)<")
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
    table_org: str
    schema_org: str
    project_type: str
    primary_key: dict[str, Any]
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
class SearcherConfig:
    repo_root: Path
    project_types: list[str]
    origin_schemas: dict[str, str]
    source: str = "db"
    include_ui_dialogs: bool = False
    include_su_tables: bool = True
    detected_version: str = ""
    dry_run: bool = False

    @property
    def effective_scan_root(self) -> Path:
        return self.repo_root


# region Table catalog

def tables_dic(schema_type: str) -> tuple[list[str], list[str]]:
    dbtables_dic = {
        "ws": {
            "dbtables": [
                "dbconfig_csv", "dbconfig_param_system", "dbconfig_form_fields",
                "dbconfig_typevalue", "dbfprocess", "dbmessage", "dbparam_user",
                "dbconfig_form_tabs", "dbconfig_report", "dbconfig_toolbox",
                "dbfunction", "dbtypevalue", "dbconfig_form_tableview",
                "dbconfig_visit_parameter", "dbtable", "dbconfig_form_fields_feat",
                "su_basic_tables", "dblabel", "dbplan_price", "dbjson",
                "dbconfig_form_fields_json",
            ],
            "sutables": ["su_basic_tables", "su_feature"],
        },
        "ud": {
            "dbtables": [
                "dbparam_user", "dbconfig_param_system", "dbconfig_form_fields",
                "dbconfig_typevalue", "dbfprocess", "dbmessage", "dbconfig_csv",
                "dbconfig_form_tabs", "dbconfig_report", "dbconfig_toolbox",
                "dbfunction", "dbtypevalue", "dbconfig_form_tableview",
                "dbconfig_visit_parameter", "dbtable", "dbconfig_form_fields_feat",
                "su_basic_tables", "dblabel", "dbplan_price", "dbjson",
                "dbconfig_form_fields_json",
            ],
            "sutables": ["su_basic_tables", "su_feature"],
        },
        "am": {
            "dbtables": ["dbconfig_engine", "dbconfig_form_tableview", "su_basic_tables"],
            "sutables": [],
        },
        "cm": {
            "dbtables": [
                "dbconfig_form_fields", "dbconfig_form_tabs", "dbconfig_param_system",
                "dbtypevalue", "dbfprocess", "dbtable", "dbconfig_form_tableview",
                "dbconfig_form_fields_json",
            ],
            "sutables": [],
        },
    }
    entry = dbtables_dic[schema_type]
    return entry["dbtables"], entry["sutables"]


def get_columns_to_compare(table_i18n: str, table_org: str, project_type: str) -> tuple[list[str], list[str]]:
    if "dbconfig_form_fields" in table_i18n and "json" not in table_i18n and "feat" not in table_i18n:
        columns_i18n = ["formname", "formtype", "tabname", "source", "lb_en_us", "tt_en_us"]
        columns_org = ["formname", "formtype", "tabname", "columnname", "label", "tooltip"]
    elif "dbparam_user" in table_i18n:
        columns_i18n = ["source", "lb_en_us", "tt_en_us"]
        columns_org = ["id", "label", "descript"]
    elif "dbconfig_param_system" in table_i18n:
        columns_i18n = ["source", "lb_en_us", "tt_en_us"]
        columns_org = ["parameter", "label", "descript"]
    elif "dbconfig_typevalue" in table_i18n:
        columns_i18n = ["formname", "source", "tt_en_us"]
        columns_org = ["typevalue", "id", "idval"]
    elif "dblabel" in table_i18n:
        columns_i18n = ["CAST(source AS INTEGER) AS source", "vl_en_us"]
        columns_org = ["id", "idval"]
    elif "dbmessage" in table_i18n:
        columns_i18n = ["CAST(source AS INTEGER) AS source", "ms_en_us", "ht_en_us"]
        columns_org = ["id", "error_message", "hint_message"]
    elif "dbfprocess" in table_i18n:
        columns_i18n = ["CAST(source AS INTEGER) AS source", "ex_en_us", "in_en_us", "na_en_us"]
        columns_org = ["fid", "except_msg", "info_msg", "fprocess_name"]
    elif "dbconfig_csv" in table_i18n:
        columns_i18n = ["CAST(source AS INTEGER) AS source", "al_en_us", "ds_en_us"]
        columns_org = ["fid", "alias", "descript"]
    elif "dbconfig_form_tabs" in table_i18n:
        columns_i18n = ["formname", "source", "lb_en_us", "tt_en_us"]
        columns_org = ["formname", "tabname", "label", "tooltip"]
    elif "dbconfig_report" in table_i18n:
        columns_i18n = ["CAST(source AS INTEGER) AS source", "al_en_us", "ds_en_us"]
        columns_org = ["id", "alias", "descript"]
    elif "dbconfig_toolbox" in table_i18n:
        columns_i18n = ["CAST(source AS INTEGER) AS source", "al_en_us", "ob_en_us"]
        columns_org = ["id", "alias", "observ"]
    elif "dbfunction" in table_i18n:
        columns_i18n = ["CAST(source AS INTEGER) AS source", "ds_en_us"]
        columns_org = ["id", "descript"]
    elif "dbtypevalue" in table_i18n:
        columns_i18n = ["typevalue", "source", "vl_en_us", "ds_en_us"]
        columns_org = ["typevalue", "id", "idval", "descript"]
    elif "dbconfig_form_tableview" in table_i18n:
        columns_i18n = ["columnname", "source", "al_en_us"]
        columns_org = ["columnname", "objectname", "alias"]
    elif "dbtable" in table_i18n:
        columns_i18n = ["source", "ds_en_us", "al_en_us"]
        columns_org = ["id", "descript", "alias"]
    elif "dbplan_price" in table_i18n:
        columns_i18n = ["source", "ds_en_us", "tx_en_us", "pr_en_us"]
        columns_org = ["id", "descript", "text", "price"]
    elif "dbconfig_visit_parameter" in table_i18n:
        columns_i18n = ["source", "ds_en_us"]
        columns_org = ["id", "descript"]
    elif "su_basic_tables" in table_i18n:
        columns_i18n = ["source", "na_en_us"]
        columns_org = ["id", "name"]
        if table_org == "value_state" and project_type in ("ud", "ws"):
            columns_i18n.append("ob_en_us")
            columns_org = ["id", "name", "observ"]
        elif project_type == "am":
            columns_org = ["id", "idval"]
    elif "su_feature" in table_i18n:
        columns_i18n = ["feature_class", "feature_type", "lb_en_us", "ds_en_us"]
        columns_org = ["feature_class", "feature_type", "id", "descript"]
    elif "dbconfig_engine" in table_i18n:
        columns_i18n = ["parameter", "method", "lb_en_us", "ds_en_us", "pl_en_us"]
        columns_org = ["parameter", "method", "label", "descript", "placeholder"]
    elif "dbstyle" in table_i18n:
        columns_i18n = ["source", "layername", "org_text", "hint", "lb_en_us"]
        columns_org = ["styleconfig_id", "layername", "stylevalue"]
    else:
        columns_i18n = ["source", "lb_en_us"]
        columns_org = ["id", "label"]

    columns_i18n = columns_i18n + ["project_type", "source_code", "context"]
    return columns_i18n, columns_org


def _normalize_i18n_columns(columns_i18n: list[str]) -> list[str]:
    result = []
    for col in columns_i18n:
        if "CAST(" in col:
            result.append(col[5:].split(" ")[0])
        else:
            result.append(col)
    return result


def find_table_org(table_i18n: str, project_type: str) -> list[str]:
    table_name = table_i18n.split(".")[-1]
    if "dbtypevalue" in table_i18n:
        if project_type in ("am", "cm"):
            return ["sys_typevalue"]
        if project_type in ("ws", "ud"):
            return ["edit_typevalue", "plan_typevalue", "om_typevalue", "inp_typevalue"]
    if "dbjson" in table_i18n:
        return ["config_report", "config_toolbox"]
    if "dbplan_price" in table_i18n:
        return ["plan_price"]
    if "dbstyle" in table_i18n:
        return ["sys_style"]
    if "dbconfig_form_fields_json" in table_i18n or "dbconfig_form_fields_feat" in table_i18n:
        return ["config_form_fields"]
    if "dbconfig_engine" in table_i18n:
        return ["config_engine", "config_engine_def"]
    if table_name.startswith("dbconfig"):
        return [table_name[2:]]
    if table_name.startswith("su_"):
        if project_type == "am":
            return ["value_result_type", "value_status"]
        if table_name == "su_feature":
            return ["cat_feature"]
        return ["value_state", "value_state_type"]
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
    for fld in _FIELDS:
        if key.startswith(fld):
            return fld
    return "msg"


def _extract_key_for(key: str) -> str:
    return 'msg = "' if "(" in key else key


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
) -> list[dict]:
    """Rows in i18n baseline whose PK no longer exists in aligned org rows."""
    pk_keys = _pk_columns(keys)
    org_pks = {_dict_to_values_tuple(row, pk_keys) for row in rows_org}
    deleted: list[dict] = []
    for row in rows_i18n:
        if _dict_to_values_tuple(row, pk_keys) not in org_pks:
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


def _text_from_en_us_columns(row: dict, en_us_columns: list[str]) -> str:
    en_us_texts = [str(row.get(c, "")) for c in en_us_columns if row.get(c)]
    return " | ".join(t for t in en_us_texts if t)


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
    pk_columns = _pk_columns(columns_i18n)
    en_us_columns = [c for c in columns_i18n if "en_us" in c]
    pk = {k: row.get(k, "") for k in pk_columns}
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

# endregion


# region Detection records and upload

def detection_key(
    table_name: str,
    table_org: str,
    schema_org: str,
    project_type: str,
    primary_keys: dict[str, Any],
    column_id: str,
    update_kind: UpdateKind,
) -> str:
    payload = {
        "table_name": table_name,
        "table_org": table_org,
        "schema_org": schema_org,
        "project_type": project_type,
        "primary_keys": primary_keys,
        "column_id": column_id,
        "kind": update_kind.value,
    }
    digest = hashlib.sha256(
        json.dumps(payload, sort_keys=True, ensure_ascii=False).encode("utf-8")
    ).hexdigest()
    return digest


def finding_to_record(finding: ExtractedString, detected_version: str) -> dict[str, Any]:
    if finding.db_location is None:
        raise ValueError("DB finding missing db_location")
    if not finding.column_id:
        raise ValueError("DB finding missing column_id")
    loc = finding.db_location
    col = finding.column_id
    record: dict[str, Any] = {
        "detection_key": detection_key(
            loc.table_i18n,
            loc.table_org,
            loc.schema_org,
            loc.project_type,
            loc.primary_key,
            col,
            finding.update_kind,
        ),
        "table_name": loc.table_i18n,
        "table_org": loc.table_org,
        "schema_org": loc.schema_org,
        "detected_version": detected_version,
        "column_id": col,
    }
    # Flat row shape aligned with GET /api/i18n/messages (metadata + PK columns)
    for key, value in loc.primary_key.items():
        record[key] = value
    if finding.update_kind == UpdateKind.TEXT_CHANGED:
        record[col] = finding.original_text
        record[f"old_{col}"] = finding.previous_text or ""
    else:
        record[col] = finding.original_text
    return record


def group_records(findings: list[ExtractedString], detected_version: str) -> dict[str, list[dict[str, Any]]]:
    grouped = {"changed": [], "deleted": [], "new": []}
    for finding in findings:
        if finding.source_type != SourceType.DB:
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


def _form_fields_feat_exclude_condition(column_prefix: str = "") -> str:
    prefix = f"{column_prefix}." if column_prefix else ""
    form_conditions = " OR ".join(
        f"({prefix}formname LIKE '{form_prefix}%%' OR {prefix}formname = '{form_prefix}')"
        for _, form_prefix in _FEAT_FORM_RULES
    )
    return f"NOT ({prefix}formtype = 'form_feature' AND ({form_conditions}))"


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

    rows_i18n = _clean_rows_i18n(
        _filter_i18n_rows(i18n_rows, table_name, project_type),
        columns_i18n,
        project_type,
        table_name,
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

    findings: list[ExtractedString] = []
    for row, update_kind, previous_row in _classify_diff_rows(expected, rows_i18n, columns_i18n):
        findings.extend(_findings_from_db_row(
            row, table_name, table_org, schema_org, project_type, columns_i18n,
            update_kind=update_kind, previous_row=previous_row,
        ))
    for row in _classify_deleted_rows(expected, rows_i18n, columns_i18n):
        findings.extend(_findings_from_db_row(
            row, table_name, table_org, schema_org, project_type, columns_i18n,
            update_kind=UpdateKind.DELETED,
        ))
    return findings


def _extract_feat_table(
    i18n_rows: list[dict],
    table_name: str,
    schema_org: str,
    project_type: str,
) -> list[ExtractedString]:
    columns_i18n = [
        "feature_type", "source_code", "project_type", "context",
        "formtype", "tabname", "source", "lb_en_us", "tt_en_us",
    ]
    rows_i18n = _clean_rows_i18n(
        _filter_i18n_rows(i18n_rows, table_name, project_type),
        columns_i18n,
        project_type,
        table_name,
    )

    form_fields_rows = _filter_i18n_rows(i18n_rows, "dbconfig_form_fields", project_type)
    expected: list[dict] = []
    for feature_type, prefix in _FEAT_FORM_RULES:
        for row in form_fields_rows:
            formname = str(row.get("formname", ""))
            if row.get("formtype") != "form_feature":
                continue
            if not (formname.startswith(prefix) or formname == prefix):
                continue
            expected.append({
                "feature_type": feature_type,
                "source_code": "giswater",
                "project_type": project_type,
                "context": "config_form_fields",
                "formtype": row.get("formtype", ""),
                "tabname": row.get("tabname", ""),
                "source": row.get("source", ""),
                "lb_en_us": row.get("lb_en_us", "") or "",
                "tt_en_us": row.get("tt_en_us", "") or "",
            })

    findings: list[ExtractedString] = []
    for row, update_kind, previous_row in _classify_diff_rows(expected, rows_i18n, columns_i18n):
        findings.extend(_findings_from_db_row(
            row, table_name, "config_form_fields", schema_org, project_type, columns_i18n,
            update_kind=update_kind, previous_row=previous_row,
        ))
    for row in _classify_deleted_rows(expected, rows_i18n, columns_i18n):
        findings.extend(_findings_from_db_row(
            row, table_name, "config_form_fields", schema_org, project_type, columns_i18n,
            update_kind=UpdateKind.DELETED,
        ))
    return findings


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

    rows_i18n = _clean_rows_i18n(
        _filter_i18n_rows(i18n_rows, table_name, project_type),
        columns_i18n,
        project_type,
        table_name,
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

    findings: list[ExtractedString] = []
    for row, update_kind, previous_row in _classify_diff_rows(aligned_org, rows_i18n, columns_i18n):
        findings.extend(_findings_from_db_row(
            row, table_name, table_org, schema_org, project_type, columns_i18n,
            update_kind=update_kind, previous_row=previous_row,
        ))
    for row in _classify_deleted_rows(aligned_org, rows_i18n, columns_i18n):
        findings.extend(_findings_from_db_row(
            row, table_name, table_org, schema_org, project_type, columns_i18n,
            update_kind=UpdateKind.DELETED,
        ))
    return findings


def extract_db_candidates(
    origin: OriginDb,
    i18n_rows: list[dict],
    config: SearcherConfig,
) -> list[ExtractedString]:
    findings: list[ExtractedString] = []

    for project_type in config.project_types:
        tables_i18n, sutables = tables_dic(project_type)
        if config.include_su_tables:
            tables_i18n = list(tables_i18n) + list(sutables)

        schema_org = config.origin_schemas.get(project_type)
        if not schema_org:
            continue

        if not origin.schema_exists(schema_org):
            log.warning("Origin schema %s does not exist", schema_org)
            continue
        if not origin.verify_lang(schema_org):
            log.warning("Origin schema %s language is not en_US/no_TR", schema_org)
            continue

        table_rows = _filter_i18n_rows(i18n_rows, "", project_type)

        for table_name in tables_i18n:
            table_i18n_rows = _filter_i18n_rows(table_rows, table_name, project_type)

            for table_org in find_table_org_with_context(table_i18n_rows, table_name, project_type):
                if not origin.table_exists(schema_org, table_org):
                    continue

                if table_name == "dbconfig_form_fields_feat":
                    findings.extend(
                        _extract_feat_table(table_i18n_rows, table_name, schema_org, project_type)
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

                rows_i18n = _clean_rows_i18n(table_i18n_rows, columns_i18n, project_type, table_name)

                cols_org_sql = ", ".join(columns_org)
                query_org = f"SELECT {cols_org_sql} FROM {schema_org}.{table_org}"
                if table_name == "dbconfig_form_fields":
                    query_org = _append_sql_condition(
                        query_org, _form_fields_feat_exclude_condition()
                    )
                rows_org = origin.fetch_all(query_org)

                rows_org = _clean_rows_org(rows_org, columns_org, project_type, table_org)
                aligned_org = _align_org_rows(
                    rows_org, columns_org, columns_i18n, project_type, table_org, is_dbstyle=False
                )

                for row, update_kind, previous_row in _classify_diff_rows(
                    aligned_org, rows_i18n, columns_i18n
                ):
                    findings.extend(_findings_from_db_row(
                        row, table_name, table_org, schema_org, project_type, columns_i18n,
                        update_kind=update_kind, previous_row=previous_row,
                    ))

                for row in _classify_deleted_rows(aligned_org, rows_i18n, columns_i18n):
                    findings.extend(_findings_from_db_row(
                        row, table_name, table_org, schema_org, project_type, columns_i18n,
                        update_kind=UpdateKind.DELETED,
                    ))

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

            findings = extract_db_candidates(origin, i18n_rows, config)
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
                f"Detections: {len(grouped['new'])} new, "
                f"{len(grouped['changed'])} changed, {len(grouped['deleted'])} deleted"
            )

            upload_detection_records(api, new_path or DEFAULT_NEW_PATH, grouped["new"], dry_run=config.dry_run)
            upload_detection_records(
                api, changed_path or DEFAULT_CHANGED_PATH, grouped["changed"], dry_run=config.dry_run
            )
            upload_detection_records(
                api, deleted_path or DEFAULT_DELETED_PATH, grouped["deleted"], dry_run=config.dry_run
            )

            api.log_out()
            log.info("Logged out from translations API")

        return 0
    except (RuntimeError, ValueError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1
    finally:
        origin.close()


if __name__ == "__main__":
    raise SystemExit(main())

# endregion
