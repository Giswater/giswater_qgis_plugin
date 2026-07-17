#!/usr/bin/env python3
"""HTTP client for the translations API (auth, GET baseline, POST detections).

Authentication matches scripts/i18n_export_zips.py::

  POST {base_url}/api/auth/sign-in/username
  {"username": "...", "password": "..."}
  POST {base_url}/api/auth/log-out

Configurable endpoints (defaults are placeholders until the API is deployed)::

  GET  /api/i18n/messages          (full baseline, no query params)
  POST /api/i18n/cat_changed_text
  POST /api/i18n/cat_delete_text
  POST /api/i18n/cat_new_text
"""

from __future__ import annotations

import json
import os
from typing import Any

import requests

SIGN_IN_PATH = "/api/auth/sign-in/username"
LOG_OUT_PATH = "/api/auth/log-out"
DEFAULT_MESSAGES_PATH = "/api/i18n/messages"
DEFAULT_CHANGED_PATH = "/api/i18n/cat_changed_text"
DEFAULT_DELETED_PATH = "/api/i18n/cat_delete_text"
DEFAULT_NEW_PATH = "/api/i18n/cat_new_text"

DEFAULT_DETECTIONS_BATCH_SIZE = 1000

# Authoritative table-specific PK columns (docs/i18n-api/get-messages.md).
TABLE_SPECIFIC_PK_COLUMNS: dict[str, tuple[str, ...]] = {
    "dbconfig_form_fields": ("formname", "formtype", "tabname", "source"),
    "dbconfig_form_fields_feat": ("feature_type", "formtype", "tabname", "source"),
    "dbconfig_form_fields_json": ("formname", "formtype", "tabname", "source", "hint"),
    "dbparam_user": ("source",),
    "dbconfig_param_system": ("source",),
    "dbconfig_typevalue": ("formname", "source"),
    "dblabel": ("source",),
    "dbmessage": ("source",),
    "dbfprocess": ("source",),
    "dbconfig_csv": ("source",),
    "dbconfig_form_tabs": ("formname", "source"),
    "dbconfig_report": ("source",),
    "dbconfig_toolbox": ("source",),
    "dbfunction": ("source",),
    "dbtypevalue": ("typevalue", "source"),
    "dbconfig_form_tableview": ("columnname", "source"),
    "dbtable": ("source",),
    "dbplan_price": ("source",),
    "dbconfig_visit_parameter": ("source",),
    "dbconfig_engine": ("parameter", "method"),
    "dbjson": ("source", "hint"),
    "dbstyle": ("source", "layername"),
    "pydialog": ("dialog_name", "toolbar_name", "source"),
    "pymessage": ("source",),
    "pytoolbar": ("source",),
}


_PY_TABLES = frozenset({"pymessage", "pytoolbar", "pydialog"})
_PY_PRIMARY_KEY_COLUMNS: dict[str, tuple[str, ...]] = {
    "pymessage": ("source", "source_code"),
    "pytoolbar": ("source", "source_code"),
    "pydialog": ("dialog_name", "toolbar_name", "source", "project_type", "source_code"),
}
_PY_DEFAULT_PROJECT_TYPE = {
    "pydialog": "utils",
}


def shared_pk_columns(table_name: str) -> tuple[str, ...]:
    return ("project_type", "context", "source_code")


def normalize_pk_value(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value).strip()


def catalog_primary_key_columns(table_name: str) -> tuple[str, ...]:
    if table_name in _PY_TABLES:
        return _PY_PRIMARY_KEY_COLUMNS[table_name]
    specific = TABLE_SPECIFIC_PK_COLUMNS.get(table_name, ("source",))
    return (*specific, *shared_pk_columns(table_name))


def primary_keys_from_row(table_name: str, row: dict[str, Any]) -> dict[str, str]:
    """Build the primary_keys object used for detection_key hashing."""
    primary_keys = {
        column: normalize_pk_value(row.get(column, ""))
        for column in catalog_primary_key_columns(table_name)
    }
    if table_name == "pydialog" and not primary_keys.get("project_type"):
        primary_keys["project_type"] = _PY_DEFAULT_PROJECT_TYPE["pydialog"]
    return primary_keys


def resolve_setting(cli_value: str | None, env_name: str, default: str | None = None) -> str | None:
    if cli_value is not None and cli_value != "":
        return cli_value
    env_value = os.environ.get(env_name)
    if env_value is not None and env_value != "":
        return env_value
    return default


class TranslationsApiClient:
    """Authenticated session for translations API GET/POST calls.

    Every request sends ``Connection: close`` and closes the response once the
    body is consumed so sockets are not left open after each call or when the
    client context exits.
    """

    def __init__(
        self,
        base_url: str,
        username: str,
        password: str,
        *,
        timeout: float = 120,
        log_out_path: str = LOG_OUT_PATH,
    ) -> None:
        if not username or not password:
            raise ValueError(
                "API credentials are required. Set TRANSLATIONS_API_USER and "
                "TRANSLATIONS_API_PASSWORD (or pass --user / --password)."
            )
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self._log_out_path = log_out_path
        self._logged_out = False
        self._session = requests.Session()
        self._sign_in(username, password)

    def _sign_in(self, username: str, password: str) -> None:
        url = f"{self.base_url}{SIGN_IN_PATH}"
        response = self._request(
            "post",
            url,
            error_message=f"Failed to reach auth API at {url}",
            json={"username": username, "password": password},
            headers=self._request_headers(content_type="application/json"),
        )
        try:
            self._raise_for_status(response, f"Login failed for {url}")
        finally:
            self._close_response(response)

    def _url(self, path: str) -> str:
        return f"{self.base_url}{path}" if path.startswith("/") else path

    def _request(
        self,
        method: str,
        url: str,
        *,
        error_message: str,
        **kwargs: Any,
    ) -> requests.Response:
        """Perform one session request and translate connection failures."""
        try:
            request = getattr(self._session, method)
            return request(url, timeout=self.timeout, **kwargs)
        except requests.RequestException as exc:
            raise RuntimeError(f"{error_message}: {exc}") from exc

    @staticmethod
    def _request_headers(
        *,
        accept: str = "application/json",
        content_type: str | None = None,
    ) -> dict[str, str]:
        headers = {"Accept": accept, "Connection": "close"}
        if content_type:
            headers["Content-Type"] = content_type
        return headers

    @staticmethod
    def _close_response(response: requests.Response) -> None:
        response.close()

    @staticmethod
    def _raise_for_status(response: requests.Response, message: str) -> None:
        if response.status_code >= 400:
            raise RuntimeError(f"{message} (HTTP {response.status_code}): {response.text}")

    @staticmethod
    def _json_response(
        response: requests.Response,
        *,
        empty_value: Any = None,
        error_message: str,
        fallback_to_text: bool = False,
    ) -> Any:
        if not response.content:
            return empty_value
        try:
            return response.json()
        except json.JSONDecodeError as exc:
            if fallback_to_text:
                return response.text
            raise RuntimeError(error_message) from exc

    def get_bytes(self, path: str, *, accept: str) -> bytes:
        url = self._url(path)
        response = self._request(
            "get",
            url,
            error_message=f"Failed to reach {url}",
            headers=self._request_headers(accept=accept),
        )
        try:
            self._raise_for_status(response, f"Request failed for {url}")
            body = response.content
            if not body:
                raise RuntimeError(f"Empty response from {url}")
            return body
        finally:
            self._close_response(response)

    def get_json(self, path: str, *, params: dict[str, Any] | None = None) -> Any:
        url = self._url(path)
        response = self._request(
            "get",
            url,
            error_message=f"GET failed for {url}",
            params=params,
            headers=self._request_headers(),
        )
        try:
            self._raise_for_status(response, f"GET {url} returned")
            return self._json_response(
                response,
                error_message=f"Invalid JSON from GET {url}",
            )
        finally:
            self._close_response(response)

    def post_json(self, path: str, payload: Any, *, with_status: bool = False) -> Any:
        url = self._url(path)
        response = self._request(
            "post",
            url,
            error_message=f"POST failed for {url}",
            json=payload,
            headers=self._request_headers(content_type="application/json"),
        )
        try:
            self._raise_for_status(response, f"POST {url} returned")
            parsed = self._json_response(
                response,
                error_message=f"Invalid JSON from POST {url}",
                fallback_to_text=True,
            )
            if with_status:
                return response.status_code, parsed
            return parsed
        finally:
            self._close_response(response)

    def log_out(self) -> None:
        """Invalidate the server session (best-effort; safe to call more than once)."""
        if self._logged_out:
            return
        self._logged_out = True
        url = self._url(self._log_out_path)
        try:
            response = self._request(
                "post",
                url,
                error_message=f"Logout failed for {url}",
                headers=self._request_headers(),
            )
        except RuntimeError:
            return
        try:
            self._raise_for_status(response, f"Logout failed for {url}")
        except RuntimeError:
            return
        finally:
            self._close_response(response)

    def close(self) -> None:
        self.log_out()
        self._session.close()

    def __enter__(self) -> TranslationsApiClient:
        return self

    def __exit__(self, *_args: Any) -> None:
        self.close()


def fetch_i18n_messages(
    api: TranslationsApiClient,
    path: str = DEFAULT_MESSAGES_PATH,
) -> list[dict[str, Any]]:
    """Fetch the full i18n baseline from the API (no query filters)."""
    payload = api.get_json(path)
    if payload is None:
        return []
    if isinstance(payload, list):
        return [row for row in payload if isinstance(row, dict)]
    if isinstance(payload, dict):
        rows = payload.get("rows") or payload.get("data") or payload.get("messages")
        if isinstance(rows, list):
            return [row for row in rows if isinstance(row, dict)]
    raise RuntimeError("Unexpected i18n messages payload: expected list or {rows|data|messages: [...]}")


def post_detection(
    api: TranslationsApiClient,
    path: str,
    records: list[dict[str, Any]],
    *,
    kind: str | None = None,
) -> dict[str, Any]:
    """POST detection records and validate the API response."""
    label = kind or path
    url = api._url(path)
    status, payload = api.post_json(path, {"records": records}, with_status=True)
    if not isinstance(payload, dict):
        raise RuntimeError(f"{label}: unexpected response from {url}: {payload!r}")
    errors = payload.get("errors") or []
    if errors:
        raise RuntimeError(
            f"{label}: POST {url} returned errors: {json.dumps(payload, ensure_ascii=False)}"
        )
    return {"kind": label, "status": status, "url": url, "response": payload}


def upload_detection_records(
    api: TranslationsApiClient,
    path: str,
    records: list[dict[str, Any]],
    *,
    dry_run: bool = False,
    kind: str | None = None,
    batch_size: int | None = None,
) -> int:
    if not records:
        return 0
    if dry_run:
        print(f"DRY-RUN POST {path}: {len(records)} record(s)")
        return len(records)

    if batch_size is None:
        batch_size = int(
            os.environ.get("I18N_DETECTIONS_BATCH_SIZE", str(DEFAULT_DETECTIONS_BATCH_SIZE))
        )
    batch_size = max(1, batch_size)

    total_inserted = 0
    total_updated = 0
    label = kind or path
    batch_count = (len(records) + batch_size - 1) // batch_size
    for batch_no, offset in enumerate(range(0, len(records), batch_size), start=1):
        chunk = records[offset: offset + batch_size]
        result = post_detection(api, path, chunk, kind=kind)
        response = result["response"]
        inserted = int(response.get("inserted") or 0)
        updated = int(response.get("updated") or 0)
        total_inserted += inserted
        total_updated += updated
        print(
            f"POST {label} batch {batch_no}/{batch_count}: HTTP {result['status']} -> "
            f"inserted={inserted} updated={updated} "
            f"errors={response.get('errors', [])}"
        )

    if batch_size < len(records):
        print(
            f"POST {label} total: inserted={total_inserted} updated={total_updated} "
            f"records={len(records)}"
        )
    return len(records)
