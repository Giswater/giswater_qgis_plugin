import traceback
from datetime import date
from typing import Any

import psycopg2

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
            with psycopg2.connect(tools_db.dao.conn_string) as conn:
                with conn.cursor() as cur:
                    if tools_db.dao.set_search_path:
                        cur.execute(tools_db.dao.set_search_path)

                    # Create workcat

                    if not self.workcat:
                        raise ValueError(
                            "Please enter a Workcat_id to proceed with this import."
                        )

                    sql = """
                        INSERT INTO cat_work (id, descript, builtdate, active)
                        VALUES (%s, %s, %s, TRUE)
                    """

                    # TODO: Pass file name
                    description = "Importing the file example.inp"
                    builtdate: date = date.today()
                    cur.execute(sql, (self.workcat, description, builtdate))

            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            return False
