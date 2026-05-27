"""
Fast pg_catalog queries for the admin dialog (avoid information_schema + N+1).
"""

from __future__ import annotations

from typing import Any, Callable, Iterable, Optional

from ...libs import tools_db

RowFetcher = Callable[[str, Optional[list]], Optional[list[tuple]]]

_SCHEMAS_WITH_SYS_VERSION = """
SELECT n.nspname
FROM pg_catalog.pg_namespace n
JOIN pg_catalog.pg_class c ON c.relnamespace = n.oid
WHERE c.relname = 'sys_version'
  AND c.relkind = 'r'
  AND n.nspname NOT LIKE 'pg_%%'
  AND n.nspname <> 'information_schema'
ORDER BY n.nspname
"""

_AUX_SCHEMAS = """
SELECT nspname
FROM pg_catalog.pg_namespace
WHERE nspname = ANY(ARRAY['am', 'cm', 'audit'])
"""


def _tools_db_fetch(sql: str, params: Optional[list] = None) -> Optional[list[tuple]]:
    rows = tools_db.get_rows(sql, commit=False, params=params, log_info=False)
    if rows is None and tools_db.dao and tools_db.dao.last_error:
        tools_db.dao.rollback()
    return rows


def _quote_ident(name: str) -> str:
    return '"' + str(name).replace('"', '""') + '"'


def _quote_literal(name: str) -> str:
    return "'" + str(name).replace("'", "''") + "'"


def fetch_schema_names_with_sys_version(fetcher: RowFetcher = _tools_db_fetch) -> list[str]:
    rows = fetcher(_SCHEMAS_WITH_SYS_VERSION, None)
    if not rows:
        return []
    return [str(row[0]) for row in rows]


def fetch_sys_version_schemas(
    project_type: Optional[str] = None,
    fetcher: RowFetcher = _tools_db_fetch,
) -> list[tuple[str, str]]:
    """Return [(schema_name, project_type), ...] in at most two round-trips."""
    schema_names = fetch_schema_names_with_sys_version(fetcher)
    if not schema_names:
        return []

    parts = [
        f"(SELECT {_quote_literal(s)} AS schema_name, project_type "
        f"FROM {_quote_ident(s)}.sys_version LIMIT 1)"
        for s in schema_names
    ]
    rows = fetcher(" UNION ALL ".join(parts), None)
    if not rows:
        return []

    result = [(str(schema_name), str(project_type)) for schema_name, project_type in rows]
    if project_type is None:
        return result

    want = project_type.upper()
    return [(s, pt) for s, pt in result if str(pt).upper() == want]


def fetch_aux_schema_flags(fetcher: RowFetcher = _tools_db_fetch) -> dict[str, bool]:
    rows = fetcher(_AUX_SCHEMAS, None)
    present = {str(row[0]) for row in rows} if rows else set()
    return {
        "am": "am" in present,
        "cm": "cm" in present,
        "audit": "audit" in present,
    }


def schema_exists(name: str, fetcher: RowFetcher = _tools_db_fetch) -> bool:
    row = fetcher("SELECT to_regnamespace(%s) IS NOT NULL", [name])
    return bool(row and row[0] and row[0][0])


def schema_names_matching(pattern: str, fetcher: RowFetcher = _tools_db_fetch) -> list[str]:
    """ILIKE match on namespace names (pg_catalog)."""
    sql = """
        SELECT nspname
        FROM pg_catalog.pg_namespace
        WHERE nspname ILIKE %s
        ORDER BY nspname
    """
    rows = fetcher(sql, [pattern])
    if not rows:
        return []
    return [str(row[0]) for row in rows]


def find_cm_schema(fetcher: RowFetcher = _tools_db_fetch) -> Optional[str]:
    for schema_name, project_type in fetch_sys_version_schemas(fetcher=fetcher):
        if str(project_type).lower() == "cm":
            return schema_name
    return None


def make_psycopg2_fetcher(conn: Any) -> RowFetcher:
    """Build a RowFetcher from an open psycopg2 connection (worker thread)."""

    def _fetch(sql: str, params: Optional[list] = None) -> Optional[list[tuple]]:
        try:
            with conn.cursor() as cur:
                cur.execute(sql, params or ())
                return cur.fetchall()
        except Exception:
            try:
                conn.rollback()
            except Exception:
                pass
            return None

    return _fetch


def combo_items_for_project_type(
    schemas: Iterable[tuple[str, str]],
    project_type: str,
) -> list[list[str]]:
    want = project_type.upper()
    return [[s, s] for s, pt in schemas if str(pt).upper() == want]
