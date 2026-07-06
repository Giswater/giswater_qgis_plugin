"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
import os
import shutil
import subprocess
import tempfile
import urllib.error
import urllib.request
import json
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


TRANSLATIONS_REPO_URL = "https://github.com/Giswater/translations/raw/main"

_LOCALE_COLUMNS = ("Active", "Locale", "Name")
_COL_ACTIVE = 0
_COL_LOCALE = 1
_COL_NAME = 2

_UI_I18N_ROOT = 'i18n'
_I18N_SCHEMAS = {'ws': 'schemas/main/ws/final_pass/i18n', 'ud': 'schemas/main/ud/final_pass/i18n', 
                'am': 'schemas/addon/am/final_pass/i18n', 'cm': 'schemas/addon/cm/final_pass/i18n',
                'python': 'i18n'}
_TS_NAME = 'giswater'


class GwI18NManageLanguagesDialog(GwI18NManageLanguagesUi):

    def __init__(self, parent_manager, parent=None):
        super().__init__(parent_manager, parent=parent)
        self._manager = parent_manager
        self.possible_locales: list[tuple[str, str, bool]] = []
        self.dev_commit = None
        self._busy_locales = set()
        self._locales_model = QStandardItemModel(0, len(_LOCALE_COLUMNS), self)
        self._locales_model.setHorizontalHeaderLabels(list(_LOCALE_COLUMNS))

    def closeEvent(self, event):
        if getattr(self, "_busy_locales", False):
            event.ignore()
            return
        super().closeEvent(event)

    def init_dialog(self):
        """ Constructor """
        tools_gw.load_settings(self)
        self.dev_commit = tools_gw.get_config_parser(
            'system', 'force_commit', "user", "init", prefix=True,
        )
        self._setup_table()
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
        for loc, _name, active in self.possible_locales:
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
        
        msg = "Downloading language files for ({0})..."
        msg_params = (locale,)
        self.lbl_downloading.setText(tools_qt.tr(msg, list_params=msg_params))
        
        self._action_download(locale)

        self.lbl_downloading.setText("")
        
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
        header.setStretchLastSection(True)
        header.setSectionResizeMode(_COL_ACTIVE, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(_COL_LOCALE, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(_COL_NAME, QHeaderView.ResizeMode.Stretch)
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
        endpoint = f"{TRANSLATIONS_REPO_URL.rstrip('/')}/languages.json"
        request = urllib.request.Request(endpoint, method="GET")
        request.add_header("Accept", "application/json")

        with urllib.request.urlopen(request, timeout=30) as response:
            payload = json.loads(response.read().decode())
        if not isinstance(payload, dict):
            raise ValueError(f"Unexpected languages payload from {endpoint}")
        return payload

    def load_downloaded_locales(self, locales: dict[str, str]) -> dict[str, str]:
        downloaded_locales = {}
        active_locales = {}
        status, cursor = tools_gw.create_sqlite_conn("config")
        if not status or cursor is None:
            msg = "Config database file not found"
            tools_qt.show_info_box(msg)
            return {}

        cursor.execute("SELECT locale, name FROM locales WHERE active = 1 ORDER BY name")
        for locale, name in cursor.fetchall():
            active_locales[locale] = name

        for locale, name in locales.items():
            if self._language_files_exist(locale):
                downloaded_locales[locale] = name
                if locale not in active_locales.keys():
                    cursor.execute("UPDATE locales SET active = 1 WHERE locale = ?", (locale,))
            else:
                if locale in active_locales.keys():
                    cursor.execute("UPDATE locales SET active = 0 WHERE locale = ?", (locale,))
        cursor.connection.commit()
        return downloaded_locales

    def load_locales(self) -> None:
        self.possible_locales = []

        api_names: dict[str, str] = {}
        try:
            languages = self.fetch_languages()
            if isinstance(languages, dict):
                api_names = {str(locale): str(name) for locale, name in languages.items()}
        except (urllib.error.URLError, urllib.error.HTTPError, OSError, json.JSONDecodeError):
            pass
        
        downloaded_locales = self.load_downloaded_locales(api_names)
        
        for locale, name in downloaded_locales.items():
            self.possible_locales.append((locale, name, True))
        
        for locale, name in api_names.items():
            if locale not in downloaded_locales.keys():
                self.possible_locales.append((locale, name, False))

    def _apply_filter(self, *_args) -> None:
        needle = tools_qt.get_text(self, self.txt_filter, return_string_null=False).strip().lower()
        self._locales_model.removeRows(0, self._locales_model.rowCount())
        item_flags = Qt.ItemFlag.ItemIsEnabled | Qt.ItemFlag.ItemIsSelectable
        for locale, name, active in self.possible_locales:
            if needle and needle not in locale.lower() and needle not in name.lower():
                continue
            active_item = QStandardItem("✓" if active else "")
            active_item.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
            active_item.setFlags(item_flags)
            locale_item = QStandardItem(locale)
            locale_item.setFlags(item_flags)
            name_item = QStandardItem(name)
            name_item.setFlags(item_flags)
            self._locales_model.appendRow([active_item, locale_item, name_item])
        self._update_action_buttons()

    @staticmethod
    def _folder_locale(locale: str) -> str:
        return locale.replace("-", "_")

    def _dbmodel_dir(self) -> str:
        return os.path.join(lib_vars.plugin_dir, 'dbmodel')

    def _locale_directories(self, locale: str) -> list[str]:
        folder = self._folder_locale(locale)
        directories = [os.path.join(lib_vars.plugin_dir, 'i18n')]
        for schema_key, schema_path in _I18N_SCHEMAS.items():
            if schema_key == 'python':
                continue
            directories.append(os.path.join(self._dbmodel_dir(), schema_path, folder))
        return directories

    def _language_files_exist(self, locale: str) -> bool:
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

    def _set_locale_active(self, locale: str, active: bool) -> bool:
        status, cursor = tools_gw.create_sqlite_conn("config")
        if not status or cursor is None:
            tools_qt.show_info_box("Config database file not found")
            return False
        cursor.execute("SELECT 1 FROM locales WHERE locale = ?", (locale,))
        if cursor.fetchone():
            cursor.execute(
                "UPDATE locales SET active = ? WHERE locale = ?",
                (1 if active else 0, locale),
            )
        else:
            name = locale
            for loc, locale_name, _active in self.possible_locales:
                if loc == locale:
                    name = locale_name
                    break
            cursor.execute(
                "INSERT INTO locales (locale, name, active) VALUES (?, ?, ?)",
                (locale, name, 1 if active else 0),
            )
        cursor.connection.commit()
        return True

    def _update_locale_state(self, locale: str, active: bool) -> None:
        for index, (loc, name, _active) in enumerate(self.possible_locales):
            if loc == locale:
                self.possible_locales[index] = (loc, name, active)
                break
        self._apply_filter()

    @staticmethod
    def _zip_lang_code(locale: str) -> str:
        return locale.strip().lower().replace("-", "_")

    def _translation_zip_urls(self, locale: str) -> list[str]:
        filename = f"translations_{self._zip_lang_code(locale)}.zip"
        base = TRANSLATIONS_REPO_URL.rstrip("/")
        urls = []
        plugin_version, _message = tools_qgis.get_plugin_version()
        if plugin_version:
            version_path = str(plugin_version).replace(".", "/")
            urls.append(f"{base}/{version_path}/{filename}")
        urls.append(f"{base}/latest/{filename}")
        return urls

    def _fetch_language_zip(self, locale: str) -> tuple[bytes | None, str | None]:
        last_error = "translation package not found"
        for url in self._translation_zip_urls(locale):
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
                    last_error = f"Not found: {url}"
                    continue
                detail = exc.read().decode(errors="replace")
                return None, f"HTTP {exc.code}: {detail}"
            except (urllib.error.URLError, OSError) as exc:
                return None, str(exc)
        return None, last_error

    def _extract_language_zip(self, locale: str, zip_data: bytes) -> tuple[bool, str | None]:
        plugin_dir = Path(lib_vars.plugin_dir).resolve()
        folder = self._folder_locale(locale)
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

            ts_path = plugin_dir / "i18n" / f"{_TS_NAME}_{folder}.ts"
            if ts_path.is_file():
                qm_path = ts_path.with_suffix(".qm")
                if not qm_path.is_file():
                    return self._compile_ts_file(ts_path)
            return True, None
        except (zipfile.BadZipFile, OSError) as exc:
            return False, str(exc)

    def resolve_lrelease(self, explicit: str | None) -> str | None:
        if explicit:
            return explicit
        lrelease_path = os.path.join(lib_vars.plugin_dir, "resources", "i18n", "lrelease.exe")
        if lrelease_path:
            return lrelease_path
        for candidate in ("lrelease", "pyside6-lrelease"):
            found = shutil.which(candidate)
            if found:
                return found
        return None

    def _compile_ts_file(self, ts_path: Path) -> tuple[bool, str | None]:
        lrelease_bin = self.resolve_lrelease(None)
        if not lrelease_bin:
            bundled = Path(lib_vars.plugin_dir) / 'resources' / 'i18n' / 'lrelease.exe'
            if bundled.is_file():
                lrelease_bin = str(bundled)
        if not lrelease_bin:
            return True, None

        qm_path = ts_path.with_suffix('.qm')
        result = subprocess.run(
            [lrelease_bin, str(ts_path), '-qm', str(qm_path)],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            detail = (result.stderr or result.stdout or '').strip()
            return False, f"lrelease failed: {detail or 'unknown error'}"
        return True, None

    def download_language_files(self, locale: str) -> tuple[bool, str | None, str | None]:
        zip_data, error = self._fetch_language_zip(locale)
        if error or not zip_data:
            return False, "zip", error or "empty response"
        ok, error = self._extract_language_zip(locale, zip_data)
        if not ok:
            return False, "zip", error or "Could not extract language files"
        return True, None, None

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
                self._update_locale_state(locale, active=False)
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

        if not self._set_locale_active(locale, True):
            return
        self._update_locale_state(locale, active=True)
        self._manager._populate_language_combo()
        if not force:
            msg = "Language files downloaded and locale activated ({0})."
            msg_params = (locale,)
            tools_qt.show_info_box(msg, msg_params=msg_params)
        else:
            msg = "Language files updated and locale activated ({0})."
            msg_params = (locale,)
            tools_qt.show_info_box(msg, msg_params=msg_params)

    def _save(self) -> None:
        status, cursor = tools_gw.create_sqlite_conn("config")
        if not status or cursor is None:
            tools_qt.show_info_box("Config database file not found")
            return
        for locale, _name, active in self.possible_locales:
            cursor.execute(
                "UPDATE locales SET active = ? WHERE locale = ?",
                (1 if active else 0, locale),
            )
        cursor.connection.commit()
        self._manager._populate_language_combo()
        self.accept()
