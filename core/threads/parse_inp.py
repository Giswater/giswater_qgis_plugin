import traceback
from pathlib import Path

import wntr

from ..ui.dialog import GwDialog
from .task import GwTask


class GwParseInpTask(GwTask):
    def __init__(self, description: str, inp_file_path: Path, dialog: GwDialog) -> None:
        super().__init__(description)
        self.inp_file_path: Path = inp_file_path
        self.dialog: GwDialog = dialog
        self.log: list[str] = []

    def run(self) -> bool:
        super().run()
        try:
            wn = wntr.network.WaterNetworkModel(self.inp_file_path)
            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            return False
