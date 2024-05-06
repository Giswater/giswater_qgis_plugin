from datetime import timedelta
from enum import Enum
from functools import partial
from pathlib import Path
from time import time
from typing import Optional, Tuple

from qgis.core import QgsApplication
from qgis.PyQt.QtCore import QTimer
from qgis.PyQt.QtWidgets import QActionGroup, QFileDialog, QLabel

from .... import global_vars
from ....libs import tools_qgis
from ...models.plugin_toolbar import GwPluginToolbar
from ...threads.parse_inp import GwParseInpTask
from ...ui.dialog import GwDialog
from ...ui.ui_manager import GwInpParsingUi
from ...utils import tools_gw
from ..dialog import GwAction


class ProjectType(Enum):
    WS = "ws"
    UD = "ud"


class GwImportInp(GwAction):
    """Button 22: Import INP"""

    def __init__(
        self,
        icon_path: str,
        action_name: str,
        text: str,
        toolbar: GwPluginToolbar,
        action_group: QActionGroup,
    ) -> None:
        super().__init__(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self) -> None:
        """Start the Import INP workflow"""

        # WS
        if global_vars.project_type == ProjectType.WS.value:
            try:
                import wntr

                file_path: Optional[Path] = self._get_file()

                if not file_path:
                    return
                
                self.parse_inp_file(file_path)

            except ImportError:
                message: str = "wntr package not installed. Open OSGeo4W Shell and execute 'python -m pip install wntr'."
                tools_qgis.show_message(message)

        # UD
        if global_vars.project_type == ProjectType.UD.value:
            try:
                import swmm_api

                file_path: Optional[Path] = self._get_file()

                if not file_path:
                    return
                
                self.parse_inp_file(file_path)

            except ImportError:
                message: str = "swmm-api package not installed. Open OSGeo4W Shell and execute 'python -m pip install swmm-api'."
                tools_qgis.show_message(message)

    def parse_inp_file(self, file_path: Path) -> None:
        """Parse INP file, showing a log to the user"""

        # Create and show parsing dialog
        self.dlg_inp_parsing = GwInpParsingUi()
        tools_gw.load_settings(self.dlg_inp_parsing)
        self.dlg_inp_parsing.rejected.connect(
            partial(tools_gw.save_settings, self.dlg_inp_parsing)
        )
        tools_gw.open_dialog(self.dlg_inp_parsing, dlg_name="parse_inp")

        self.parse_inp_task = GwParseInpTask("Parse INP task", file_path)
        QgsApplication.taskManager().addTask(self.parse_inp_task)
        QgsApplication.taskManager().triggerTask(self.parse_inp_task)

        # Create timer
        self.t0: float = time()
        self.timer: QTimer = QTimer()
        self.timer.timeout.connect(
            partial(self._calculate_elapsed_time, self.dlg_inp_parsing)
        )
        self.timer.start(1000)

    def _calculate_elapsed_time(self, dialog: GwDialog) -> None:
        tf: float = time()  # Final time
        td: float = tf - self.t0  # Delta time
        self._update_time_elapsed(f"Exec. time: {timedelta(seconds=round(td))}", dialog)

    def _get_file(self) -> Optional[Path]:
        # Load a select file dialog for select a file with .inp extension
        result: Tuple[str, str] = QFileDialog.getOpenFileName(
            None, "Select an INP file", "", "INP files (*.inp)"
        )
        file_path_str: str = result[0]
        if file_path_str:
            file_path: Path = Path(file_path_str)

            # Check if the file extension is .inp
            if file_path.suffix == ".inp":
                return file_path
            else:
                tools_qgis.show_warning("The file selected is not an INP file")
                return

    def _update_time_elapsed(self, text: str, dialog: GwDialog) -> None:
        lbl_time: QLabel = dialog.findChild(QLabel, "lbl_time")
        lbl_time.setText(text)
