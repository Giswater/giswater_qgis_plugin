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
        filepath,
        network,
        workcat,
        exploitation,
        sector,
        catalogs,
    ) -> None:
        super().__init__(description)
        self.filepath = filepath
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
            # Some validations
            if not self.workcat:
                message = "Please enter a Workcat_id to proceed with this import."
                raise ValueError(message)
            
            if not self.exploitation:
                message = "Please select an exploitation to proceed with this import."
                raise ValueError(message)
            
            if not self.sector:
                message = "Please select a sector to proceed with this import."
                raise ValueError(message)
            
            with psycopg2.connect(tools_db.dao.conn_string) as conn:
                with conn.cursor() as cur:
                    if tools_db.dao.set_search_path:
                        cur.execute(tools_db.dao.set_search_path)

                    # Create workcat

                    sql = """
                        INSERT INTO cat_work (id, descript, builtdate, active)
                        VALUES (%s, %s, %s, TRUE)
                    """

                    description = f"Importing the file {self.filepath.name}"
                    builtdate: date = date.today()
                    cur.execute(sql, (self.workcat, description, builtdate))

            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            return False
