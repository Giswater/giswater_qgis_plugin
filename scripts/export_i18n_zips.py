#!/usr/bin/env python3
"""Download translation ZIP exports from the translations API for CI workflows.

Authentication uses a cookie session obtained from::

  POST {base_url}/api/auth/sign-in/username
  {"username": "...", "password": "..."}

Example::

  python scripts/export_i18n_zips.py \\
    --base-url "$TRANSLATIONS_API_URL" \\
    --user "$TRANSLATIONS_API_USER" \\
    --password "$TRANSLATIONS_API_PASSWORD" \\
    --languages es_cr,es_es \\
    --output-dir ./artifacts

Environment variables override defaults when CLI flags are omitted:
  TRANSLATIONS_API_URL, TRANSLATIONS_API_USER, TRANSLATIONS_API_PASSWORD,
  LANG_CODE (comma-separated), TS_NAME.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.parse
from pathlib import Path
from typing import Any

import requests

DEFAULT_TS_NAME = "giswater"
SIGN_IN_PATH = "/api/auth/sign-in/username"
ZIP_MAGIC = b"PK"


def resolve_setting(cli_value: str | None, env_name: str, default: str | None = None) -> str | None:
    if cli_value is not None and cli_value != "":
        return cli_value
    env_value = os.environ.get(env_name)
    if env_value is not None and env_value != "":
        return env_value
    return default


class ApiSession:
    """Authenticated HTTP session for the translations API."""

    def __init__(
        self,
        base_url: str,
        username: str,
        password: str,
        *,
        timeout: float = 120,
    ) -> None:
        if not username or not password:
            raise ValueError(
                "API credentials are required. Set TRANSLATIONS_API_USER and "
                "TRANSLATIONS_API_PASSWORD (or pass --user / --password)."
            )

        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self._session = requests.Session()
        self._sign_in(username, password)

    def _sign_in(self, username: str, password: str) -> None:
        url = f"{self.base_url}{SIGN_IN_PATH}"
        try:
            response = self._session.post(
                url,
                json={"username": username, "password": password},
                timeout=self.timeout,
            )
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to reach auth API at {url}: {exc}") from exc

        if response.status_code >= 400:
            raise RuntimeError(
                f"Login failed (HTTP {response.status_code}) for {url}: {response.text}"
            )

    def get_bytes(self, path: str, *, accept: str) -> bytes:
        url = f"{self.base_url}{path}" if path.startswith("/") else path
        headers = {"Accept": accept, "Connection": "close"}

        try:
            response = self._session.get(url, headers=headers, timeout=self.timeout)
        except requests.RequestException as exc:
            raise RuntimeError(f"Failed to reach {url}: {exc}") from exc

        if response.status_code >= 400:
            raise RuntimeError(f"HTTP {response.status_code} for {url}: {response.text}")

        body = response.content
        if not body:
            raise RuntimeError(f"Empty response from {url}")
        return body

    def close(self) -> None:
        self._session.close()

    def __enter__(self) -> ApiSession:
        return self

    def __exit__(self, *_args: Any) -> None:
        self.close()


def fetch_languages_dict(api: ApiSession) -> dict[str, str]:
    body = api.get_bytes("/api/languages", accept="application/json")
    try:
        payload = json.loads(body.decode("utf-8"))
    except json.JSONDecodeError as exc:
        raise RuntimeError("Invalid JSON from /api/languages") from exc

    if not isinstance(payload, dict):
        raise RuntimeError("Unexpected languages payload from /api/languages: expected object")

    languages = {
        str(locale).strip().lower(): str(name)
        for locale, name in payload.items()
        if str(locale).strip()
    }
    if not languages:
        raise RuntimeError("No languages returned from /api/languages")
    return languages


def normalize_lang(lang: str) -> str:
    return lang.strip().lower().replace("-", "_")


def zip_filename(lang: str) -> str:
    return f"translations_{normalize_lang(lang)}.zip"


def build_export_path(lang: str, ts_name: str) -> str:
    query = urllib.parse.urlencode({"ts_name": ts_name})
    return f"/api/translations/{normalize_lang(lang)}/export/zip?{query}"


def download_zip(
    api: ApiSession,
    lang: str,
    ts_name: str,
    output_dir: Path,
) -> Path:
    path = build_export_path(lang, ts_name)
    url = f"{api.base_url}{path}"
    print(f"GET {url}")

    body = api.get_bytes(path, accept="application/zip, application/octet-stream, */*")
    if not body.startswith(ZIP_MAGIC):
        raise RuntimeError(
            f"Response for {lang} is not a ZIP archive (missing PK header). "
            f"Received {len(body)} byte(s)."
        )

    output_dir.mkdir(parents=True, exist_ok=True)
    target = output_dir / zip_filename(lang)
    target.write_bytes(body)
    print(f"Wrote {target} ({len(body)} bytes)")
    return target


def parse_languages(raw: str | None) -> list[str] | None:
    if raw is None or raw.strip() == "" or raw.strip().lower() == "all":
        return None
    langs = [normalize_lang(part) for part in raw.split(",") if part.strip()]
    if not langs:
        raise ValueError("No valid language codes provided.")
    return langs


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download translation ZIP files from the translations API.",
    )
    parser.add_argument("--base-url", default=None, help="Translations API base URL")
    parser.add_argument("--user", default=None, help="API username")
    parser.add_argument("--password", default=None, help="API password")
    parser.add_argument(
        "--languages",
        default=None,
        help="Comma-separated language codes, or 'all' to fetch from /api/languages",
    )
    parser.add_argument("--ts-name", default=None, help=f"TS base name (default: {DEFAULT_TS_NAME})")
    parser.add_argument("--output-dir", default="artifacts/i18n", help="Directory for ZIP files")
    parser.add_argument(
        "--languages-json-out",
        default=None,
        help="Optional path to write languages.json from /api/languages",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    base_url = (resolve_setting(args.base_url, "TRANSLATIONS_API_URL") or "").strip()
    user = (resolve_setting(args.user, "TRANSLATIONS_API_USER", "") or "").strip()
    password = (resolve_setting(args.password, "TRANSLATIONS_API_PASSWORD", "") or "").strip()
    ts_name = resolve_setting(args.ts_name, "TS_NAME", DEFAULT_TS_NAME) or DEFAULT_TS_NAME
    languages_raw = resolve_setting(args.languages, "LANG_CODE", None)
    output_dir = Path(args.output_dir)

    if not base_url:
        print(
            "Error: missing API base URL. Set TRANSLATIONS_API_URL or pass --base-url.",
            file=sys.stderr,
        )
        return 1

    try:
        with ApiSession(base_url, user, password) as api:
            languages = parse_languages(languages_raw)
            languages_dict: dict[str, str] | None = None
            if languages is None or args.languages_json_out:
                print("Fetching language list from API...")
                languages_dict = fetch_languages_dict(api)

            if args.languages_json_out:
                languages_json_path = Path(args.languages_json_out)
                languages_json_path.parent.mkdir(parents=True, exist_ok=True)
                languages_json_path.write_text(
                    json.dumps(languages_dict, ensure_ascii=False, indent=2) + "\n",
                    encoding="utf-8",
                )
                print(f"Wrote {languages_json_path} ({len(languages_dict)} language(s))")

            if languages is None:
                languages = sorted(languages_dict.keys())
                print(f"Languages: {', '.join(languages)}")

            failures = 0
            downloaded: list[Path] = []
            for lang in languages:
                try:
                    downloaded.append(download_zip(api, lang, ts_name, output_dir))
                except RuntimeError as exc:
                    print(f"Error exporting {lang}: {exc}", file=sys.stderr)
                    failures += 1

            if downloaded:
                print(f"Downloaded {len(downloaded)} ZIP file(s) to {output_dir.resolve()}")

            if failures:
                print(f"Failed to export {failures} language(s).", file=sys.stderr)
                return 1
        return 0
    except (RuntimeError, ValueError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
