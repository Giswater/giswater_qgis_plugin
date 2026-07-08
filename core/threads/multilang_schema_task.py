"""
Asynchronous task: create multilang schema and seed en_US baseline rows.
"""

from __future__ import annotations

import json
from typing import Any, Callable

from qgis.PyQt.QtCore import pyqtSignal

from ...giswater_admin.adapters.psycopg2_adapter import Psycopg2Adapter
from ...giswater_admin.engine import (
    BuildParams,
    BuildResult,
    CancelToken,
    Manifest,
    SchemaBuilder,
)
from ...giswater_admin.log_format import (
    LogStyle,
    format_build_header,
    format_done,
    format_failure,
    format_file,
    format_progress_status,
)
from ...libs import lib_vars, tools_db, tools_log
from ..admin._admin_catalog import fetch_schema_inventory, make_psycopg2_fetcher
from ..admin.i18n_baseline_seed import (
    SEED_LANGUAGE_FOLDER,
    SEED_LANGUAGE_ID,
    compute_baseline_fingerprint,
    delete_schema_seed_sql,
    fetch_seeded_schema_names_from_multilang,
    seed_sql_for_schema,
)
from ..admin.i18n_languages import _I18N_SCHEMAS
from .schema_builder_task import load_kind_manifest
from .task import GwTask


class GwMultilangSchemaTask(GwTask):
    """Build multilang schema, then populate translation tables from baselines."""

    task_finished = pyqtSignal(bool)

    def __init__(
        self,
        admin: Any,
        params: BuildParams,
        *,
        description: str = "Create multilang schema",
        timer: Any = None,
        on_done: Callable[[BuildResult], None] | None = None,
        manage_schemas_dlg: Any = None,
    ) -> None:
        super().__init__(description)
        self.admin = admin
        self.params = params
        self.timer = timer
        self.on_done = on_done
        self.manage_schemas_dlg = manage_schemas_dlg

        if params.cancel_token is None:
            params.cancel_token = CancelToken()

        self.manifest: Manifest = load_kind_manifest(admin.plugin_dir, "multilang")
        self.result: BuildResult | None = None
        self.seeded_schemas: list[str] = []
        self._last_progress_label = ""
        self._log_style = LogStyle(
            sql_root=params.sql_root or "",
            show_timing_ms=False,
        )
        self._adapter: Psycopg2Adapter | None = None

    def _set_task_error(self, message: str) -> None:
        text = str(message or "").strip() or "Multilang schema task failed."
        lib_vars.session_vars["last_error"] = text
        lib_vars.session_vars["last_error_msg"] = text
        tools_log.log_warning("Multilang schema task", parameter=text)

    def _execute_sql(self, sql: str) -> bool:
        if self._adapter is None:
            self._set_task_error("Database connection is not available.")
            return False
        if not self._adapter.execute(sql):
            self._set_task_error(self._adapter.last_error() or "SQL execution failed.")
            return False
        return True

    def run(self) -> bool:
        super().run()
        lib_vars.session_vars["last_error"] = None
        lib_vars.session_vars["last_error_msg"] = None

        if self.aux_conn is None or isinstance(self.aux_conn, dict):
            self._set_task_error("Could not open database connection for multilang task.")
            return False

        self._adapter = Psycopg2Adapter(self.aux_conn)

        fetcher = make_psycopg2_fetcher(self.aux_conn)
        translatable_before = self._translatable_schemas(fetcher)

        tools_log.log_info(
            format_build_header(
                self.manifest.kind,
                self.params.schema_name,
                self.params.profile,
                self.params.plugin_version,
                style=self._log_style,
            )
        )

        builder = SchemaBuilder(
            self._adapter,
            self.manifest,
            self.params,
            progress_cb=self._progress_cb_build,
            commit_each_file=bool(getattr(self.admin, "dev_commit", False)),
        )
        try:
            self.result = builder.run()
        except Exception as exc:  # noqa: BLE001
            self.exception = exc
            self._set_task_error(str(exc))
            tools_log.log_info("Multilang SchemaBuilder exception", parameter=str(exc))
            return False

        if self.result.cancelled or not self.result.ok:
            self._record_failure()
            if self._adapter is not None:
                self._adapter.rollback()
            return False

        fetcher = make_psycopg2_fetcher(self.aux_conn)
        translatable_after = self._translatable_schemas(fetcher)
        target_schemas = translatable_after or translatable_before
        if not target_schemas:
            tools_log.log_info(
                "Multilang seed: no schemas with bundled baselines detected; skipping import."
            )
            self._finalize_addparam([])
            return True

        if not self._ensure_cat_language():
            return False

        current_names = sorted(name for name, _ in target_schemas)
        if not self._remove_orphaned_schema_rows(fetcher, set(current_names)):
            if self._adapter is not None:
                self._adapter.rollback()
            return False

        seeded: list[str] = []
        total = len(target_schemas)
        for idx, (schema_name, project_type) in enumerate(target_schemas, start=1):
            if self.isCanceled():
                self.params.cancel_token.cancel()
                return False

            self._progress_cb_seed(idx, total, schema_name)
            statements = seed_sql_for_schema(
                self.params.sql_root or "",
                schema_name,
                project_type=project_type,
                lang=SEED_LANGUAGE_ID,
            )
            if not statements:
                tools_log.log_info(
                    f"Multilang seed: no baseline SQL for schema {schema_name} "
                    f"(project_type={project_type}); skipping."
                )
            else:
                for sql in statements:
                    if self.isCanceled():
                        return False
                    if not self._execute_sql(sql):
                        if self._adapter is not None:
                            err = self._adapter.last_error() or "seed SQL failed"
                            self._set_task_error(
                                f"Multilang seed failed for schema {schema_name}: {err}"
                            )
                            self._adapter.rollback()
                        return False
            seeded.append(schema_name)

        self.seeded_schemas = seeded
        if not self._finalize_addparam(current_names):
            if self._adapter is not None:
                self._adapter.rollback()
            return False

        if self._adapter is not None:
            self._adapter.commit()
        return True

    def _translatable_schemas(self, fetcher) -> list[tuple[str, str]]:
        targets: list[tuple[str, str]] = []
        for row in fetch_schema_inventory(fetcher):
            kind = str(row.get("kind") or "").lower()
            schema_name = str(row.get("schema") or "")
            if not schema_name or not kind or kind not in _I18N_SCHEMAS or kind == "python":
                continue
            targets.append((schema_name, kind))
        return sorted(set(targets))

    def _stored_seeded_schemas(self, fetcher) -> set[str]:
        return fetch_seeded_schema_names_from_multilang(fetcher)

    def _remove_orphaned_schema_rows(
        self,
        fetcher,
        current_schema_names: set[str],
    ) -> bool:
        stored = self._stored_seeded_schemas(fetcher)
        removed = sorted(stored - current_schema_names)
        if not removed:
            return True
        tools_log.log_info(
            "Multilang seed: removing baseline rows for deleted schemas",
            parameter=", ".join(removed),
        )
        for sql in delete_schema_seed_sql(removed):
            if self.isCanceled():
                return False
            if not self._execute_sql(sql):
                self._set_task_error(
                    self._adapter.last_error() if self._adapter else
                    "Failed to delete multilang rows for removed schemas."
                )
                return False
        return True

    def _ensure_cat_language(self) -> bool:
        sql = (
            f"INSERT INTO multilang.cat_language (id, idval) "
            f"VALUES ('{SEED_LANGUAGE_ID}', '{SEED_LANGUAGE_FOLDER}') "
            "ON CONFLICT (id) DO NOTHING;"
        )
        return self._execute_sql(sql)

    def _finalize_addparam(self, seeded_schemas: list[str]) -> bool:
        payload = json.dumps({
            "seeded_schemas": seeded_schemas,
            "seed_language": SEED_LANGUAGE_FOLDER,
            "seed_baseline_fingerprint": compute_baseline_fingerprint(
                self.params.sql_root or "",
            ),
        }).replace("'", "''")
        sql = (
            "UPDATE multilang.sys_version "
            f"SET addparam = COALESCE(addparam, '{{}}'::jsonb) || '{payload}'::jsonb "
            "WHERE id = (SELECT id FROM multilang.sys_version ORDER BY id DESC LIMIT 1);"
        )
        return self._execute_sql(sql)

    def _record_failure(self) -> None:
        if self.result is None:
            if self._adapter is not None and self._adapter.last_error():
                self._set_task_error(self._adapter.last_error())
            return
        failure = self.result.first_failure()
        if failure is None:
            if self._adapter is not None and self._adapter.last_error():
                self._set_task_error(self._adapter.last_error())
            return
        err = (
            (self._adapter.last_error() if self._adapter is not None else "")
            or lib_vars.session_vars.get("last_error")
            or failure.error
            or ""
        )
        lib_vars.session_vars["last_error"] = err
        msg = format_failure(
            failure.path,
            str(failure.error or err),
            sql_root=self._log_style.sql_root,
            sql=getattr(failure, "sql", "") or "",
            statement_position=getattr(failure, "statement_position", 0) or 0,
        )
        if err and not lib_vars.session_vars.get("last_error_msg"):
            lib_vars.session_vars["last_error_msg"] = msg
        tools_log.log_warning("Multilang schema build failed", parameter=msg)

    def _progress_cb_build(
        self,
        seen: int,
        total: int,
        label: str,
        fx: Any = None,
    ) -> None:
        self._last_progress_label = label
        if label == "done":
            tools_log.log_info(format_done(seen, total, style=self._log_style))
        elif not label.startswith("phase:"):
            tools_log.log_info(format_file(seen, total, label, style=self._log_style))

        if hasattr(self.admin, "schema_build_progress_hint"):
            self.admin.schema_build_progress_hint = format_progress_status(
                seen,
                total,
                label,
                sql_root=self._log_style.sql_root,
            )

        if total > 0:
            pct = int(round((seen / total) * 80))
            if hasattr(self.admin, "progress_ratio"):
                pct = int(pct * float(self.admin.progress_ratio or 1.0))
            if hasattr(self.admin, "current_sql_file"):
                self.admin.current_sql_file = seen
            if hasattr(self.admin, "total_sql_files"):
                self.admin.total_sql_files = total
            if hasattr(self.admin, "progress_value"):
                self.admin.progress_value = pct
            self.setProgress(pct)

        if self.isCanceled():
            self.params.cancel_token.cancel()

    def _progress_cb_seed(self, seen: int, total: int, schema_name: str) -> None:
        label = f"seed:{schema_name}"
        self._last_progress_label = label
        if hasattr(self.admin, "schema_build_progress_hint"):
            self.admin.schema_build_progress_hint = f"Seeding {schema_name} ({seen}/{total})"
        pct = 80 + int(round((seen / max(total, 1)) * 20))
        if hasattr(self.admin, "progress_value"):
            self.admin.progress_value = pct
        self.setProgress(pct)

    def finished(self, result: bool) -> None:
        super().finished(result)
        if self.timer is not None:
            try:
                self.timer.stop()
            except Exception:  # noqa: BLE001
                pass
        self.setProgress(100)

        dlg = self.manage_schemas_dlg
        if dlg is not None:
            try:
                dlg.setEnabled(True)
            except Exception:  # noqa: BLE001
                pass

        if self.on_done is not None and self.result is not None:
            if not result and self.result.ok:
                self.admin.error_count = getattr(self.admin, "error_count", 0) + 1
                if not lib_vars.session_vars.get("last_error_msg"):
                    self._set_task_error(
                        self._adapter.last_error() if self._adapter else
                        "Multilang schema task failed during baseline seed."
                    )
            try:
                self.on_done(self.result)
            except Exception as exc:  # noqa: BLE001
                tools_log.log_info("Multilang on_done callback raised", parameter=str(exc))

        self.task_finished.emit(bool(result))

    def cancel(self) -> None:
        try:
            self.params.cancel_token.cancel()
        except Exception:  # noqa: BLE001
            pass
        super().cancel()
