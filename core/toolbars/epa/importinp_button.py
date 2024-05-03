from enum import Enum

from qgis.PyQt.QtWidgets import QActionGroup

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
                tools_qgis.show_message("OK")
            except ImportError:
                message: str = "wntr package not installed. Open OSGeo4W Shell and execute 'python -m pip install wntr'."
                tools_qgis.show_message(message)

        # UD
        if global_vars.project_type == ProjectType.UD.value:
            try:
                import swmm_api
                tools_qgis.show_message("OK")
            except ImportError:
                message: str = "swmm-api package not installed. Open OSGeo4W Shell and execute 'python -m pip install swmm-api'."
                tools_qgis.show_message(message)
