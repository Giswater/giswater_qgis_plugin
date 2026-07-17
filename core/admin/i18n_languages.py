"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
import json
import os
import re
import shutil
import tempfile
import urllib.error
import urllib.request
import zipfile
from pathlib import Path

from qgis.core import QgsApplication
from qgis.PyQt.QtCore import QEvent, Qt
from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import (
    QHeaderView, QAbstractItemView,
)

from ..ui.ui_manager import GwI18NManageLanguagesUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_qt, tools_qgis
from ..threads.i18n_download_task import GwDownloadLanguageTask


TRANSLATIONS_REPO_URL = "https://github.com/giswater/translations/raw/main"
TRANSLATIONS_GITHUB_TREE_URL = (
    "https://api.github.com/repos/Giswater/translations/git/trees/main?recursive=1"
)
_VERSION_FOLDER_RE = re.compile(r"^(\d+)/(\d+)/(\d+)$")

_LOCALE_COLUMNS = ("Active", "Locale", "Name")
_COL_ACTIVE = 0
_COL_LOCALE = 1
_COL_NAME = 2
_COL_VERSION = 3

_I18N_SCHEMAS = {'ws': 'schemas/main/ws/final_pass/i18n', 'ud': 'schemas/main/ud/final_pass/i18n', 
                'am': 'schemas/addon/am/final_pass/i18n', 'cm': 'schemas/addon/cm/final_pass/i18n',
                'python': 'i18n'}
_TS_NAME = 'giswater'


class GwI18NManageLanguagesDialog(GwI18NManageLanguagesUi):

    _available_versions_cache: list[str] | None = None

    def __init__(self, parent_manager, parent=None):
        super().__init__(parent_manager, parent=parent)
        self._manager = parent_manager
        self.possible_locales: list[tuple[str, str, bool, str | None]] = []
        self._busy_locales = set()

        # Add version column if advanced user and create the model
        columns = list(_LOCALE_COLUMNS)
        if self._is_advanced_user():
            columns.append("Version")
            self._col_version = len(columns) - 1
        else:
            self._col_version = None

        self._locales_model = QStandardItemModel(0, len(columns), self)
        self._locales_model.setHorizontalHeaderLabels(columns)

    def closeEvent(self, event):
        if getattr(self, "_busy_locales", False):
            event.ignore()
            return
        self._save_download_options()
        super().closeEvent(event)

    def init_dialog(self):
        """ Constructor """
        tools_gw.load_settings(self)
        self._setup_table()
        self._setup_download_options()
        self.load_locales()
        self._apply_filter()
        self._set_signals()
        self._update_action_buttons()
        tools_gw.open_dialog(self, dlg_name='admin_i18n_languages')

    def _set_signals(self) -> None:
        self.txt_filter.textChanged.connect(partial(self._apply_filter))
        selection = self.tbl_locales.selectionModel()
        if selection is not None:
            selection.selectionChanged.connect(partial(self._update_action_buttons))
        self.btn_close.clicked.connect(partial(tools_gw.close_dialog, self))
        self.btn_delete.clicked.connect(partial(self._on_delete))
        self.btn_download.clicked.connect(partial(self._on_download))
        self.btn_update.clicked.connect(partial(self._on_update))
        self.tbl_locales.doubleClicked.connect(partial(self._on_double_click))
        if self._is_advanced_user():
            self.chk_download_latest.stateChanged.connect(partial(self._save_download_options))

    @staticmethod
    def _is_advanced_user() -> bool:
        allowed_levels = lib_vars.user_level.get('showadminadvanced')
        if allowed_levels is None:
            allowed_levels = tools_gw.get_config_parser(
                'user_level', 'showadminadvanced', "user", "init", False,
            )
            lib_vars.user_level['showadminadvanced'] = allowed_levels

        user_level = lib_vars.user_level.get('level')
        if user_level in (None, "None"):
            user_level = tools_gw.get_config_parser('user_level', 'level', "user", "init", False)
            lib_vars.user_level['level'] = user_level

        if not allowed_levels or user_level in (None, "None"):
            return False
        return str(user_level) in str(allowed_levels)

    def _setup_download_options(self) -> None:
        advanced = self._is_advanced_user()
        self.chk_download_latest.setVisible(advanced)
        if not advanced:
            return
        value = tools_gw.get_config_parser(
            'i18n_languages', 'chk_download_latest', "user", "init", False,
        )
        if value is not None:
            tools_qt.set_checked(self, 'chk_download_latest', value)

    def _save_download_options(self, *_args) -> None:
        if not self._is_advanced_user():
            return
        checked = tools_qt.is_checked(self, 'chk_download_latest')
        tools_gw.set_config_parser(
            'i18n_languages', 'chk_download_latest', f"{checked}",
            "user", "init", prefix=False,
        )

    def _use_latest_translation(self) -> bool:
        return (
            self._is_advanced_user()
            and self.chk_download_latest.isVisible()
            and tools_qt.is_checked(self, 'chk_download_latest')
        )

    def _selected_locale(self) -> str:
        selection = self.tbl_locales.selectionModel()
        if selection is None:
            return ""
        indexes = selection.selectedRows(_COL_LOCALE)
        if not indexes:
            return ""
        item = self._locales_model.item(indexes[0].row(), _COL_LOCALE)
        return item.text() if item else ""
    
    def _selected_language(self) -> str:
        selection = self.tbl_locales.selectionModel()
        if selection is None:
            return ""
        indexes = selection.selectedRows(_COL_NAME)
        if not indexes:
            return ""
        item = self._locales_model.item(indexes[0].row(), _COL_NAME)
        return item.text() if item else ""

    def _selected_locale_active(self) -> tuple[bool, str] | None:
        locale = self._selected_locale()
        if not locale:
            return None, None
        for loc, _name, active, _version in self.possible_locales:
            if loc == locale:
                return active, locale
        return False, None

    def _update_action_buttons(self) -> None:
        active, locale = self._selected_locale_active()
        language = self._selected_language()
        if active is None:
            self.lbl_language.setText("Select a language to manage")
            self.btn_download.setVisible(False)
            self.btn_update.setVisible(False)
            self.btn_delete.setVisible(False)
            return

        self.lbl_language.setText(f"Language: {language}")
        
        if locale.lower() == "en_us":
            self.btn_download.setVisible(False)
            self.btn_update.setVisible(True)
            self.btn_delete.setVisible(False)
            return

        self.btn_download.setVisible(not active)
        self.btn_update.setVisible(active)
        self.btn_delete.setVisible(active)

    def _on_download(self) -> None:
        locale = self._selected_locale()
        if not locale:
            msg = "Select a locale"
            tools_qt.show_info_box(msg)
            return
        self._action_download(locale)
        
    def _on_update(self) -> None:
        locale = self._selected_locale()
        if not locale:
            msg = "Select a locale"
            tools_qt.show_info_box(msg)
            return
        
        msg = f"Do you want to update local language files for ({locale})?"
        title = "Update language files?"
        msg_params = (locale,)
        if not tools_qt.show_question(msg, title, msg_params=msg_params):
            return
        
        msg = "Updating language files for ({0})..."
        msg_params = (locale,)
        self.lbl_downloading.setText(tools_qt.tr(msg, list_params=msg_params))

        self._action_delete(locale, force=True)
        self._action_download(locale, force=True)

    def _on_delete(self) -> None:
        locale = self._selected_locale()
        if not locale:
            msg = "Select a locale"
            tools_qt.show_info_box(msg)
            return
        self._action_delete(locale)

    def _on_double_click(self) -> None:
        locale = self._selected_locale()
        if not locale:
            return
        if not self._language_files_exist(locale):
            self._on_download()

    def _setup_table(self) -> None:
        self.tbl_locales.setModel(self._locales_model)
        self.tbl_locales.setAlternatingRowColors(True)
        self.tbl_locales.setSortingEnabled(True)
        self.tbl_locales.setEditTriggers(QAbstractItemView.EditTrigger.NoEditTriggers)
        self.tbl_locales.verticalHeader().setVisible(False)

        header = self.tbl_locales.horizontalHeader()
        header.setStretchLastSection(False)
        header.setSectionResizeMode(_COL_ACTIVE, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(_COL_LOCALE, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(_COL_NAME, QHeaderView.ResizeMode.Stretch)
        if self._col_version is not None:
            header.setSectionResizeMode(_COL_VERSION, QHeaderView.ResizeMode.ResizeToContents)
            header.resizeSection(_COL_VERSION, 72)
        header.setMinimumSectionSize(48)
        self.tbl_locales.viewport().installEventFilter(self)

    def eventFilter(self, watched, event):
        if watched is self.tbl_locales.viewport():
            if (
                event.type() == QEvent.Type.MouseButtonPress
                and event.button() == Qt.MouseButton.LeftButton
            ):
                index = self.tbl_locales.indexAt(event.pos())
                if index.isValid():
                    selection = self.tbl_locales.selectionModel()
                    if selection is not None and selection.isSelected(index):
                        selection.clearSelection()
                        return True
        return super().eventFilter(watched, event)

    @staticmethod
    def fetch_languages() -> dict:
        endpoint = f"{TRANSLATIONS_REPO_URL.rstrip('/')}/latest/languages.json"
        request = urllib.request.Request(endpoint, method="GET")
        request.add_header("Accept", "application/json")

        with urllib.request.urlopen(request, timeout=30) as response:
            payload = json.loads(response.read().decode())
        if not isinstance(payload, dict):
            raise ValueError(f"Unexpected languages payload from {endpoint}")
        return payload

    def load_downloaded_locales(self, locales: dict[str, str]) -> dict[str, tuple[str, str | None]]:
        downloaded_locales: dict[str, tuple[str, str | None]] = {}
        status, cursor = tools_gw.create_sqlite_conn("config")
        if not status or cursor is None:
            msg = "Config database file not found"
            tools_qt.show_info_box(msg)
            return {}

        cursor.execute("SELECT locale, name, active, version FROM locales")
        db_locales = {
            locale: (name, active, version)
            for locale, name, active, version in cursor.fetchall()
        }

        dirty = False
        for locale, name in locales.items():
            if self._language_files_exist(locale):
                db_name, db_active, version = db_locales.get(locale, (name, 0, None))
                downloaded_locales[locale] = (db_name or name, version)
                if locale in db_locales:
                    if db_active == 0:
                        cursor.execute("UPDATE locales SET active = 1 WHERE locale = ?", (locale,))
                        dirty = True
                else:
                    cursor.execute(
                        "INSERT INTO locales (locale, name, active, version) VALUES (?, ?, 1, ?)",
                        (locale, name, version),
                    )
                    dirty = True
            elif locale in db_locales and db_locales[locale][1]:
                cursor.execute(
                    "UPDATE locales SET active = 0, version = NULL WHERE locale = ?",
                    (locale,),
                )
                dirty = True
        if dirty:
            cursor.connection.commit()
            self._manager._populate_language_combo()
        return downloaded_locales

    def load_locales(self) -> None:
        self.possible_locales = []

        api_names: dict[str, str] = {}
        try:
            languages = self.fetch_languages()
            if isinstance(languages, dict):
                for locale, name in languages.items():
                    locale_parts = str(locale).split("_")
                    locale = locale_parts[0].lower() + "_" + locale_parts[1].upper()
                    api_names[locale] = name
                    print(f"locale: {locale}")
                    print(f"name: {name}")
        except (urllib.error.URLError, urllib.error.HTTPError, OSError, json.JSONDecodeError):
            pass
        
        downloaded_locales = self.load_downloaded_locales(api_names)
        
        for locale, (name, version) in downloaded_locales.items():
            self.possible_locales.append((locale, name, True, version))
        
        for locale, name in api_names.items():
            if locale not in downloaded_locales.keys():
                self.possible_locales.append((locale, name, False, None))

    def _apply_filter(self, *_args) -> None:
        needle = tools_qt.get_text(self, self.txt_filter, return_string_null=False).strip().lower()
        self._locales_model.removeRows(0, self._locales_model.rowCount())
        item_flags = Qt.ItemFlag.ItemIsEnabled | Qt.ItemFlag.ItemIsSelectable
        for locale, name, active, version in self.possible_locales:
            if needle and needle not in locale.lower() and needle not in name.lower():
                continue
            active_item = QStandardItem("✓" if active else "")
            active_item.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
            active_item.setFlags(item_flags)
            locale_item = QStandardItem(locale)
            locale_item.setFlags(item_flags)
            name_item = QStandardItem(name)
            name_item.setFlags(item_flags)
            if self._col_version is not None:
                version_item = QStandardItem(version or "")
                version_item.setFlags(item_flags)
                self._locales_model.appendRow([active_item, locale_item, name_item, version_item])
            else:
                self._locales_model.appendRow([active_item, locale_item, name_item])
        self._update_action_buttons()

    @staticmethod
    def _folder_locale(locale: str) -> str:
        return locale.replace("-", "_")

    def _dbmodel_dir(self) -> str:
        return os.path.join(lib_vars.plugin_dir, 'dbmodel')

    def _language_files_exist(self, locale: str) -> bool:
        if locale.lower() == "en_us":
            return True
            
        folder = self._folder_locale(locale)
        ts_path = os.path.join(lib_vars.plugin_dir, 'i18n', f'{_TS_NAME}_{folder}.ts')
        if not os.path.isfile(ts_path):
            return False
        for schema_key, schema_path in _I18N_SCHEMAS.items():
            if schema_key == 'python':
                continue
            path = os.path.join(self._dbmodel_dir(), schema_path, folder)
            if not os.path.isdir(path) or not any(name.endswith('.sql') for name in os.listdir(path)):
                self._delete_language_files(locale)
                return False
        return True

    def _set_locale_active(
        self,
        locale: str,
        active: bool,
        version: str | None = None,
    ) -> bool:
        status, cursor = tools_gw.create_sqlite_conn("config")
        if not status or cursor is None:
            tools_qt.show_info_box("Config database file not found")
            return False
        cursor.execute("SELECT 1 FROM locales WHERE locale = ?", (locale,))
        if cursor.fetchone():
            if version is not None:
                cursor.execute(
                    "UPDATE locales SET active = ?, version = ? WHERE locale = ?",
                    (1 if active else 0, version, locale),
                )
            elif not active:
                cursor.execute(
                    "UPDATE locales SET active = ?, version = NULL WHERE locale = ?",
                    (0, locale),
                )
            else:
                cursor.execute(
                    "UPDATE locales SET active = ? WHERE locale = ?",
                    (1, locale),
                )
        else:
            name = locale
            for loc, locale_name, _active, _version in self.possible_locales:
                if loc == locale:
                    name = locale_name
                    break
            cursor.execute(
                "INSERT INTO locales (locale, name, active, version) VALUES (?, ?, ?, ?)",
                (locale, name, 1 if active else 0, version),
            )
        cursor.connection.commit()
        return True

    def _update_locale_state(self, locale: str, active: bool, version: str | None) -> None:
        for index, (loc, name, _active, _version) in enumerate(self.possible_locales):
            if loc == locale:
                self.possible_locales[index] = (loc, name, active, version)
                break
        self._apply_filter()

    @staticmethod
    def _zip_lang_code(locale: str) -> str:
        return locale.strip().lower().replace("-", "_")

    @staticmethod
    def _parse_semver(version: str | None) -> tuple[int, int, int] | None:
        if not version:
            return None
        text = str(version).strip().lstrip("v")
        parts = text.split(".")
        if len(parts) != 3 or not all(part.isdigit() for part in parts):
            return None
        return tuple(int(part) for part in parts)

    @classmethod
    def _format_version(cls, version: tuple[int, int, int]) -> str:
        return ".".join(str(part) for part in version)

    @classmethod
    def _version_to_path(cls, version: str) -> str:
        parsed = cls._parse_semver(version)
        if parsed is None:
            return "latest"
        return "/".join(str(part) for part in parsed)

    @classmethod
    def _fetch_json(cls, endpoint: str) -> dict | list | None:
        request = urllib.request.Request(endpoint, method="GET")
        request.add_header("Accept", "application/json")
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                payload = json.loads(response.read().decode())
        except (urllib.error.URLError, urllib.error.HTTPError, OSError, json.JSONDecodeError):
            return None
        return payload

    @classmethod
    def _parse_versions_payload(cls, payload: dict | list | None) -> list[str]:
        if isinstance(payload, list):
            versions = [str(item) for item in payload if cls._parse_semver(str(item))]
        elif isinstance(payload, dict):
            versions = [
                str(item)
                for item in payload.get("versions", [])
                if cls._parse_semver(str(item))
            ]
        else:
            return []
        return cls._sort_versions(versions)

    @classmethod
    def _sort_versions(cls, versions: list[str]) -> list[str]:
        parsed = [
            (cls._parse_semver(version), version)
            for version in versions
            if cls._parse_semver(version) is not None
        ]
        parsed.sort(key=lambda item: item[0])
        return [version for _key, version in parsed]

    @classmethod
    def fetch_available_versions(cls) -> list[str]:
        endpoint = f"{TRANSLATIONS_REPO_URL.rstrip('/')}/versions.json"
        versions = cls._parse_versions_payload(cls._fetch_json(endpoint))
        if versions:
            return versions

        payload = cls._fetch_json(TRANSLATIONS_GITHUB_TREE_URL)
        if not isinstance(payload, dict):
            return []

        discovered: set[str] = set()
        for entry in payload.get("tree", []):
            if entry.get("type") != "tree":
                continue
            match = _VERSION_FOLDER_RE.match(str(entry.get("path", "")))
            if not match:
                continue
            discovered.add(".".join(match.groups()))
        return cls._sort_versions(sorted(discovered))

    @classmethod
    def _get_available_versions(cls) -> list[str]:
        if cls._available_versions_cache is None:
            cls._available_versions_cache = cls.fetch_available_versions()
        return cls._available_versions_cache

    @classmethod
    def resolve_translation_version_path(
        cls,
        user_version: str | None,
        available_versions: list[str] | None = None,
    ) -> str:
        """Pick the translations folder (``major/minor/patch`` or ``latest``)."""
        versions = available_versions if available_versions is not None else cls._get_available_versions()
        user = cls._parse_semver(user_version)

        if user is None or not versions:
            if user_version:
                return cls._version_to_path(user_version)
            return "latest"

        user_label = cls._format_version(user)
        parsed_versions = [
            (cls._parse_semver(version), version)
            for version in versions
            if cls._parse_semver(version) is not None
        ]
        parsed_versions.sort(key=lambda item: item[0])
        if not parsed_versions:
            return cls._version_to_path(user_version or "")

        available_labels = [version for _key, version in parsed_versions]
        if user_label in available_labels:
            return cls._version_to_path(user_label)

        highest = parsed_versions[-1][0]
        if user > highest:
            return "latest"

        for version_key, version_label in parsed_versions:
            if version_key >= user:
                return cls._version_to_path(version_label)

        return "latest"

    def _translation_zip_url(self, locale: str) -> str:
        filename = f"translations_{self._zip_lang_code(locale)}.zip"
        base = TRANSLATIONS_REPO_URL.rstrip("/")
        if self._use_latest_translation():
            version_path = "latest"
        else:
            plugin_version, _message = tools_qgis.get_plugin_version()
            version_path = self.resolve_translation_version_path(plugin_version)
        return f"{base}/{version_path}/{filename}"

    def _fetch_language_zip(self, locale: str) -> tuple[bytes | None, str | None]:
        url = self._translation_zip_url(locale)
        request = urllib.request.Request(url, method="GET")
        request.add_header("Accept", "application/zip, application/octet-stream, */*")
        try:
            with urllib.request.urlopen(request, timeout=120) as response:
                body = response.read()
            if not body.startswith(b"PK"):
                return None, f"Response from {url} is not a ZIP archive"
            return body, None
        except urllib.error.HTTPError as exc:
            if exc.code == 404:
                return None, f"Not found: {url}"
            detail = exc.read().decode(errors="replace")
            return None, f"HTTP {exc.code}: {detail}"
        except (urllib.error.URLError, OSError) as exc:
            return None, str(exc)

    def _extract_language_zip(self, locale: str, zip_data: bytes) -> tuple[bool, str | None]:
        plugin_dir = Path(lib_vars.plugin_dir).resolve()

        try:
            with tempfile.TemporaryDirectory() as tmpdir:
                zip_path = Path(tmpdir) / "translations.zip"
                zip_path.write_bytes(zip_data)
                with zipfile.ZipFile(zip_path) as archive:
                    for member in archive.namelist():
                        if member.endswith("/"):
                            continue
                        target = (plugin_dir / member).resolve()
                        if not str(target).startswith(str(plugin_dir)):
                            return False, f"Unsafe path in ZIP archive: {member}"
                    archive.extractall(plugin_dir)
            
        except (zipfile.BadZipFile, OSError) as exc:
            return False, str(exc)

        manifest_path = plugin_dir / 'manifest.json'
        if manifest_path.exists():
            try:
                manifest_path.unlink()
            except Exception as exc:
                return False, f"Could not delete manifest.json: {exc}"
   
        return True, None

    def download_language_files(self, locale: str) -> tuple[bool, str | None, str | None]:
        zip_data, error = self._fetch_language_zip(locale)
        if error or not zip_data:
            return False, "zip", error or "empty response"
        ok, error = self._extract_language_zip(locale, zip_data)
        if not ok:
            return False, "zip", error or "Could not extract language files"
        return True, None, None

    def _translation_version_label(self) -> str:
        if self._use_latest_translation():
            return "latest"
        plugin_version, _ = tools_qgis.get_plugin_version()
        path = self.resolve_translation_version_path(plugin_version)
        if path == "latest":
            return "latest"
        return path.replace("/", ".")

    def _delete_language_files(self, locale: str) -> tuple[bool, str | None]:
        removed = False
        folder = self._folder_locale(locale)
        try:
            for suffix in ('.ts', '.qm'):
                ts_path = os.path.join(lib_vars.plugin_dir, 'i18n', f'{_TS_NAME}_{folder}{suffix}')
                if os.path.isfile(ts_path):
                    os.remove(ts_path)
                    removed = True
            for schema_key, schema_path in _I18N_SCHEMAS.items():
                if schema_key == 'python':
                    continue
                path = os.path.join(self._dbmodel_dir(), schema_path, folder)
                if os.path.isdir(path):
                    shutil.rmtree(path)
                    removed = True
            if not removed:
                return False, "no local language folders found"
            return True, None
        except OSError as exc:
            return False, str(exc)

    def _run_locale_action(self, locale: str, action) -> None:
        if locale in self._busy_locales:
            return
        self._busy_locales.add(locale)
        self.setEnabled(False)
        try:
            action()
        finally:
            self._busy_locales.discard(locale)
            self.setEnabled(True)

    def _action_download(self, locale: str, force: bool = False) -> None:
        if locale in self._busy_locales:
            return
        msg = f"Do you want to download local language files for ({locale})?"
        title = "Download language files?"
        msg_params = (locale,)
        if not force and not tools_qt.show_question(msg, title, msg_params=msg_params):
            return

        self._busy_locales.add(locale)
        self.setEnabled(False)
        self.lbl_downloading.setText(tools_qt.tr("Downloading language files for ({0})...", list_params=(locale,)))

        task = GwDownloadLanguageTask(self, locale)
        task.task_finished.connect(partial(self._on_download_finished, force))
        self._download_task = task
        QgsApplication.taskManager().addTask(task)

    def _action_delete(self, locale: str, force: bool = False) -> None:
        def _delete() -> None:
            if not self._language_files_exist(locale):
                tools_qt.show_info_box(
                    "No language files found for ({0}).",
                    msg_params=(locale,),
                )
                return
            msg = f"Delete local language files for ({locale})?"
            title = "Delete language files"
            msg_params = (locale,)
            if not force and not tools_qt.show_question(msg, title, msg_params=msg_params):
                return
            ok, error = self._delete_language_files(locale)
            if not ok:
                msg = "Could not delete language files ({0}): {1}",
                msg_params = (locale, error or "unknown error")
                tools_qt.show_info_box(msg, msg_params=msg_params)
                return
                
            if not force:
                if not self._set_locale_active(locale, False):
                    return
                self._update_locale_state(locale, active=False, version=None)
                self._manager._populate_language_combo()
                msg = "Language files deleted and locale deactivated ({0})."
                msg_params = (locale,)
                tools_qt.show_info_box(msg, msg_params=msg_params)

        self._run_locale_action(locale, _delete)
    
    def _on_download_finished(self, force, ok, locale, schema, error):
        self.lbl_downloading.setText("")
        self._busy_locales.discard(locale)
        self.setEnabled(True)

        if not ok:
            msg = "Could not download language files ({0}, {1}): {2}",
            msg_params = (locale, schema, error or "unknown error")
            tools_qt.show_info_box(msg, msg_params=msg_params)
            return

        version = self._translation_version_label()
        if not self._set_locale_active(locale, True, version=version):
            return
        self._update_locale_state(locale, active=True, version=version)
        self._manager._populate_language_combo()
        if not force:
            msg = "Language files downloaded and locale activated ({0})."
            msg_params = (locale,)
            tools_qt.show_info_box(msg, msg_params=msg_params)
        else:
            msg = "Language files updated and locale activated ({0})."
            msg_params = (locale,)
            tools_qt.show_info_box(msg, msg_params=msg_params)
