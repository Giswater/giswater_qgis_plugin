import traceback
from typing import Any

# from wntr.network.model import WaterNetworkModel

from ...libs import tools_db
from .task import GwTask


class GwImportInpTask(GwTask):
    def __init__(
        self,
        description: str,
        network,
        workcat,
        exploitation,
        sector,
        catalogs,
    ) -> None:
        super().__init__(description)
        # self.network: WaterNetworkModel = network
        self.network = network
        self.workcat: str = workcat
        self.exploitation: str = exploitation
        self.sector: str = sector
        self.catalogs: dict[str, Any] = catalogs
        self.log: list[str] = []

    def run(self) -> bool:
        super().run()
        try:
            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            return False
