from datetime import timedelta
from enum import Enum
from functools import partial
from pathlib import Path
from time import time
from typing import Optional, Tuple

from qgis.core import QgsApplication
from qgis.PyQt.QtCore import Qt, QTimer
from qgis.PyQt.QtWidgets import (
    QActionGroup,
    QComboBox,
    QFileDialog,
    QLabel,
    QTableWidget,
    QTableWidgetItem,
    QTextEdit,
)
from sip import isdeleted

from ..... import global_vars
from .....libs import tools_db, tools_qgis, tools_qt
from ....models.plugin_toolbar import GwPluginToolbar
from ....ui.dialog import GwDialog
from ....ui.ui_manager import GwInpConfigImportUi, GwInpParsingUi
from ....threads.import_inp.import_inp import GwImportInpTask
from ....utils import tools_gw
from ...dialog import GwAction

CREATE_NEW = "Create new"
TESTING_MODE = True


class ProjectType(Enum):
    WS = "ws"
    UD = "ud"


class GwImportSwmm:
    """Button 22: Import INP"""

    def __init__(self) -> None:
        self.file_path: Optional[Path] = None
        self.cur_process = None
        self.cur_text = None

    def clicked_event(self) -> None:
        """Start the Import INP workflow"""

        msg = "Import INP is only available for WS (WNTR projects)"
        tools_qgis.show_warning(msg)
