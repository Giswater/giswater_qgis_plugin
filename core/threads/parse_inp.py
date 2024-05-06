from pathlib import Path

import wntr

from .task import GwTask


class GwParseInpTask(GwTask):
    def __init__(self, description: str, inp_file_path: Path) -> None:
        super().__init__(description)
        self.inp_file_path: Path = inp_file_path

    def run(self) -> bool:
        return super().run()
