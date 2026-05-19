"""
Generic ``QgsTask`` wrapper around :class:`giswater_admin.engine.SchemaBuilder`.

This single task replaces the six legacy ``project_schema_*_create.py``
classes. The Admin dialog builds a :class:`BuildParams`, picks a
manifest, and submits one of these. Progress events bridge to the
existing ``admin.progress_value`` / ``setProgress()`` machinery for
the dialog's progress bar; cancellation flips the engine's cancel
token between files.
"""

from __future__ import annotations

import os
from typing import Any, Callable

from qgis.PyQt.QtCore import pyqtSignal
from qgis.PyQt.sip import isdeleted

from ...giswater_admin.engine import (
    BuildParams,
    BuildResult,
    CancelToken,
    Manifest,
    SchemaBuilder,
    load_manifest,
)
from ...giswater_admin.engine.timing_report import summarize_build
from ...giswater_admin.log_format import (
    LogStyle,
    format_build_header,
    format_done,
    format_failure,
    format_file,
    format_phase,
    format_progress_status,
    format_timing_summary,
)
from ...libs import lib_vars, tools_db, tools_log
from ..admin._qt_db_adapter import QtDbAdapter
from .task import GwTask


def _log_schema_lines(lines: list[str]) -> None:
    for line in lines:
        tools_log.log_info(line)


class GwSchemaBuilderTask(GwTask):
    """One task that handles every schema kind via a manifest."""

    task_finished = pyqtSignal(bool)

    def __init__(
        self,
        admin: Any,
        manifest: Manifest,
        params: BuildParams,
        *,
        description: str = "Build schema",
        timer: Any = None,
        on_done: Callable[[BuildResult], None] | None = None,
    ) -> None:
        super().__init__(description)
        self.admin = admin
        self.manifest = manifest
        self.params = params
        self.timer = timer
        self.on_done = on_done

        # Cooperative cancellation. The engine checks the token between
        # files; QgsTask.cancel() flips it.
        if params.cancel_token is None:  # belt and braces
            params.cancel_token = CancelToken()

        self.db_exception: tuple[Any, str, str] | None = None  # (error, sql, filepath)
        self.result: BuildResult | None = None
        self._last_progress_label: str = ""
        self._log_style = LogStyle(
            sql_root=params.sql_root or "",
            show_timing_ms=True,
        )

        # Detect "force commit" preference (legacy `system/force_commit`),
        # so SQL bodies that historically were committed mid-flight stay so.
        dev_commit = getattr(admin, "dev_commit", False)
        self._adapter = QtDbAdapter(dev_commit=bool(dev_commit))

    # ------------------------------------------------------------------ run

    def run(self) -> bool:
        super().run()
        lib_vars.session_vars["last_error"] = None
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
            progress_cb=self._progress_cb,
        )
        try:
            self.result = builder.run()
        except Exception as e:  # noqa: BLE001 - boundary
            self.exception = e
            tools_log.log_info("SchemaBuilder exception", parameter=str(e))
            return False

        if self.result.cancelled:
            return False

        if not self.result.ok:
            failure = self.result.first_failure()
            if failure is not None:
                err = lib_vars.session_vars.get("last_error") or failure.error or ""
                lib_vars.session_vars["last_error"] = err
                if err and not lib_vars.session_vars.get("last_error_msg"):
                    lib_vars.session_vars["last_error_msg"] = format_failure(
                        failure.path,
                        str(err),
                        sql_root=self._log_style.sql_root,
                    )
                self.db_exception = (err, "", failure.path)
                tools_log.log_warning(
                    "SchemaBuilder failed",
                    parameter=format_failure(
                        failure.path,
                        str(failure.error or err),
                        sql_root=self._log_style.sql_root,
                    ),
                )
            else:
                tools_log.log_warning("SchemaBuilder failed without first_failure")
            if self.result is not None:
                self._log_timing_summary(self.result)
            return False

        if self.result is not None:
            self._log_timing_summary(self.result)
        return True

    def _log_timing_summary(self, result: BuildResult) -> None:
        summary = summarize_build(result, top=15)
        _log_schema_lines(format_timing_summary(summary, style=self._log_style))

    # ------------------------------------------------------------- progress

    def _progress_cb(
        self,
        seen: int,
        total: int,
        label: str,
        fx: Any = None,
    ) -> None:
        self._last_progress_label = label
        ms = None
        if fx is not None and getattr(fx, "duration_ms", 0):
            ms = int(fx.duration_ms)

        if label.startswith("phase:"):
            phase_id = label.split(":", 1)[1]
            tools_log.log_info(format_phase(seen, total, phase_id, style=self._log_style))
        elif label == "done":
            tools_log.log_info(format_done(seen, total, style=self._log_style))
        else:
            tools_log.log_info(
                format_file(seen, total, label, ms=ms, style=self._log_style)
            )

        if hasattr(self.admin, "schema_build_progress_hint"):
            self.admin.schema_build_progress_hint = format_progress_status(
                seen,
                total,
                label,
                sql_root=self._log_style.sql_root,
            )

        # Mirror legacy `progress_value = (current/total) * 100 * 0.8`
        # so the existing label/timer logic in admin_btn keeps working.
        if total > 0:
            pct = int(round((seen / total) * 100))
            if hasattr(self.admin, "progress_ratio"):
                pct = int(pct * float(self.admin.progress_ratio or 1.0))
            if hasattr(self.admin, "current_sql_file"):
                self.admin.current_sql_file = seen
            if hasattr(self.admin, "total_sql_files"):
                self.admin.total_sql_files = total
            if hasattr(self.admin, "progress_value"):
                self.admin.progress_value = pct
            self.setProgress(pct)

        # Forward cancel intent into the engine's token (cheap idempotent).
        if self.isCanceled():
            self.params.cancel_token.cancel()

    # ----------------------------------------------------------- finished

    def finished(self, result: bool) -> None:
        super().finished(result)
        if self.timer is not None:
            try:
                self.timer.stop()
            except Exception:  # noqa: BLE001
                pass
        self.setProgress(100)

        if self.on_done is not None and self.result is not None:
            try:
                self.on_done(self.result)
            except Exception as e:  # noqa: BLE001
                tools_log.log_info("on_done callback raised", parameter=str(e))

        self.task_finished.emit(bool(result))

    # ---------------------------------------------------------------- cancel

    def cancel(self) -> None:
        try:
            self.params.cancel_token.cancel()
        except Exception:  # noqa: BLE001
            pass
        super().cancel()


# --------------------------------------------------------- convenience helpers


def load_kind_manifest(plugin_dir: str, kind: str) -> Manifest:
    """Convenience: load the manifest bundled at ``dbmodel/manifests/<kind>.yaml``."""
    path = os.path.join(plugin_dir, "dbmodel", "manifests", f"{kind}.yaml")
    return load_manifest(path)
