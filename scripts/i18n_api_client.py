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
        try:
            response = self._session.post(
                url,
                json={"username": username, "password": password},
                headers=self._request_headers(content_type="application/json"),
                timeout=self.timeout,
            )
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to reach auth API at {url}: {exc}") from exc
        try:
            if response.status_code >= 400:
                raise RuntimeError(
                    f"Login failed (HTTP {response.status_code}) for {url}: {response.text}"
                )
        finally:
            self._close_response(response)

    def _url(self, path: str) -> str:
        return f"{self.base_url}{path}" if path.startswith("/") else path

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

    def get_bytes(self, path: str, *, accept: str) -> bytes:
        url = self._url(path)
        try:
            response = self._session.get(
                url,
                headers=self._request_headers(accept=accept),
                timeout=self.timeout,
            )
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to reach {url}: {exc}") from exc
        try:
            if response.status_code >= 400:
                raise RuntimeError(f"HTTP {response.status_code} for {url}: {response.text}")
            body = response.content
            if not body:
                raise RuntimeError(f"Empty response from {url}")
            return body
        finally:
            self._close_response(response)

    def get_json(self, path: str, *, params: dict[str, Any] | None = None) -> Any:
        url = self._url(path)
        try:
            response = self._session.get(
                url,
                params=params,
                headers=self._request_headers(),
                timeout=self.timeout,
            )
        except requests.RequestException as exc:
            raise RuntimeError(f"GET failed for {url}: {exc}") from exc
        try:
            if response.status_code >= 400:
                raise RuntimeError(
                    f"GET {url} returned HTTP {response.status_code}: {response.text}"
                )
            if not response.content:
                return None
            try:
                return response.json()
            except json.JSONDecodeError as exc:
                raise RuntimeError(f"Invalid JSON from GET {url}") from exc
        finally:
            self._close_response(response)

    def post_json(self, path: str, payload: Any) -> Any:
        url = self._url(path)
        try:
            response = self._session.post(
                url,
                json=payload,
                headers=self._request_headers(content_type="application/json"),
                timeout=self.timeout,
            )
        except requests.RequestException as exc:
            raise RuntimeError(f"POST failed for {url}: {exc}") from exc
        try:
            if response.status_code >= 400:
                raise RuntimeError(
                    f"POST {url} returned HTTP {response.status_code}: {response.text}"
                )
            if not response.content:
                return None
            try:
                return response.json()
            except json.JSONDecodeError:
                return response.text
        finally:
            self._close_response(response)

    def log_out(self) -> None:
        """Invalidate the server session (best-effort; safe to call more than once)."""
        if self._logged_out:
            return
        self._logged_out = True
        url = self._url(self._log_out_path)
        try:
            response = self._session.post(
                url,
                headers=self._request_headers(),
                timeout=self.timeout,
            )
        except requests.RequestException:
            return
        try:
            if response.status_code >= 400:
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


def upload_detection_records(
    api: TranslationsApiClient,
    path: str,
    records: list[dict[str, Any]],
    *,
    dry_run: bool = False,
) -> int:
    if not records:
        return 0
    if dry_run:
        print(f"DRY-RUN POST {path}: {len(records)} record(s)")
        return len(records)
    api.post_json(path, {"records": records})
    return len(records)
