from enum import Enum
from pathlib import Path
from typing import Optional

from qgis.PyQt.QtWidgets import QActionGroup, QFileDialog

from .... import global_vars
from ....libs import tools_qgis
from ...models.plugin_toolbar import GwPluginToolbar
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
            except ImportError:
                message: str = "wntr package not installed. Open OSGeo4W Shell and execute 'python -m pip install wntr'."
                tools_qgis.show_message(message)

        # UD
        if global_vars.project_type == ProjectType.UD.value:
            try:
                import swmm_api

                file_path: Optional[Path] = self._get_file()
            except ImportError:
                message: str = "swmm-api package not installed. Open OSGeo4W Shell and execute 'python -m pip install swmm-api'."
                tools_qgis.show_message(message)

    def _get_file(self) -> Optional[Path]:
        # Load a select file dialog for select a file with .inp extension
        file_path, _ = QFileDialog.getOpenFileName(
            None, "Select an INP file", "", "INP files (*.inp)"
        )
        if file_path:
            file_path = Path(file_path)

            # Check if the file extension is .inp
            if file_path.suffix == ".inp":
                return file_path
            else:
                tools_qgis.show_warning("The file selected is not an INP file")
                return
