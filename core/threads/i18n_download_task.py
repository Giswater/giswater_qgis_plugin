from qgis.PyQt.QtCore import pyqtSignal
from .task import GwTask

class GwDownloadLanguageTask(GwTask):
    task_finished = pyqtSignal(bool, str, str, str)  # ok, locale, schema, error

    def __init__(self, dialog, locale: str):
        super().__init__(f"Download language files for {locale}")
        self.use_aux_conn = False   # no PostgreSQL — skip aux DB conn
        self.dialog = dialog
        self.locale = locale
        self.failed_schema = None
        self.error = None

    def run(self) -> bool:
        super().run()
        try:
            if self.isCanceled():
                return False

            self.setProgress(10)
            ok, schema, error = self.dialog.download_language_files(self.locale)
            if not ok:
                self.failed_schema = schema
                self.error = error or "Could not download language files"
                return False

            self.setProgress(100)
            return True
        except Exception as exc:
            self.exception = exc
            return False

    def finished(self, result: bool) -> None:
        super().finished(result)
        self.setProgress(100)
        self.task_finished.emit(
            bool(result),
            self.locale,
            self.failed_schema or "",
            self.error or "",
        )
