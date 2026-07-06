#!/usr/bin/env python3
"""Download translation ZIP exports from the translations API for CI workflows.

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
import base64
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

DEFAULT_TS_NAME = "giswater"
ZIP_MAGIC = b"PK"


def resolve_setting(cli_value: str | None, env_name: str, default: str | None = None) -> str | None:
    if cli_value is not None and cli_value != "":
        return cli_value
    env_value = os.environ.get(env_name)
    if env_value is not None and env_value != "":
        return env_value
    return default


def build_auth_header(user: str, password: str) -> str:
    if not user or not password:
        raise ValueError(
            "API credentials are required. Set TRANSLATIONS_API_USER and "
            "TRANSLATIONS_API_PASSWORD (or pass --user / --password)."
        )
    token = base64.b64encode(f"{user}:{password}".encode("utf-8")).decode("ascii")
    return f"Basic {token}"


def request_url(
    url: str,
    *,
    user: str,
    password: str,
    accept: str,
    timeout: int = 120,
) -> bytes:
    request = urllib.request.Request(url, method="GET")
    request.add_header("Authorization", build_auth_header(user, password))
    request.add_header("Accept", accept)

    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            body = response.read()
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode(errors="replace")
        raise RuntimeError(f"HTTP {exc.code} for {url}: {detail}") from exc
    except urllib.error.URLError as exc:
        raise RuntimeError(f"Failed to reach {url}: {exc}") from exc

    if not body:
        raise RuntimeError(f"Empty response from {url}")
    return body


def fetch_languages_dict(base_url: str, user: str, password: str) -> dict[str, str]:
    url = f"{base_url.rstrip('/')}/api/languages"
    body = request_url(url, user=user, password=password, accept="application/json")
    try:
        payload = json.loads(body.decode("utf-8"))
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"Invalid JSON from {url}") from exc

    if not isinstance(payload, dict):
        raise RuntimeError(f"Unexpected languages payload from {url}: expected object")

    languages = {
        str(locale).strip().lower(): str(name)
        for locale, name in payload.items()
        if str(locale).strip()
    }
    if not languages:
        raise RuntimeError(f"No languages returned from {url}")
    return languages


def fetch_languages(base_url: str, user: str, password: str) -> list[str]:
    return sorted(fetch_languages_dict(base_url, user, password).keys())


def write_languages_json(path: Path, base_url: str, user: str, password: str) -> None:
    languages = fetch_languages_dict(base_url, user, password)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(languages, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {path} ({len(languages)} language(s))")


def normalize_lang(lang: str) -> str:
    return lang.strip().lower().replace("-", "_")


def zip_filename(lang: str) -> str:
    return f"translations_{normalize_lang(lang)}.zip"


def build_export_url(base_url: str, lang: str, ts_name: str) -> str:
    query = urllib.parse.urlencode({"ts_name": ts_name})
    return f"{base_url.rstrip('/')}/api/translations/{normalize_lang(lang)}/export/zip?{query}"


def download_zip(
    base_url: str,
    lang: str,
    ts_name: str,
    output_dir: Path,
    user: str,
    password: str,
) -> Path:
    url = build_export_url(base_url, lang, ts_name)
    print(f"GET {url}")

    body = request_url(
        url,
        user=user,
        password=password,
        accept="application/zip, application/octet-stream, */*",
    )
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

    base_url = resolve_setting(args.base_url, "TRANSLATIONS_API_URL")
    user = resolve_setting(args.user, "TRANSLATIONS_API_USER", "")
    password = resolve_setting(args.password, "TRANSLATIONS_API_PASSWORD", "")
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
        if args.languages_json_out:
            write_languages_json(Path(args.languages_json_out), base_url, user, password)

        languages = parse_languages(languages_raw)
        if languages is None:
            print("Fetching language list from API...")
            languages = fetch_languages(base_url, user, password)
            print(f"Languages: {', '.join(languages)}")

        failures = 0
        for lang in languages:
            try:
                download_zip(base_url, lang, ts_name, output_dir, user, password)
            except RuntimeError as exc:
                print(f"Error exporting {lang}: {exc}", file=sys.stderr)
                failures += 1

        if failures:
            print(f"Failed to export {failures} language(s).", file=sys.stderr)
            return 1
        return 0
    except (RuntimeError, ValueError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
