/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Fk 51
-- ----------------------------
--DROP
ALTER TABLE "rtc_scada_node" DROP CONSTRAINT IF EXISTS "rtc_scada_node_scada_id_fkey";
ALTER TABLE "rtc_scada_node" DROP CONSTRAINT IF EXISTS "rtc_scada_node_node_id_fkey";

ALTER TABLE "rtc_scada_x_dma" DROP CONSTRAINT IF EXISTS "rtc_scada_x_dma_scada_id_fkey";
ALTER TABLE "rtc_scada_x_dma" DROP CONSTRAINT IF EXISTS "rtc_scada_x_dma_dma_id_fkey";

ALTER TABLE "rtc_scada_x_sector" DROP CONSTRAINT IF EXISTS "rtc_scada_x_sector_scada_id_fkey";
ALTER TABLE "rtc_scada_x_sector" DROP CONSTRAINT IF EXISTS "rtc_scada_x_sector_sector_id_fkey";

ALTER TABLE "rtc_hydrometer_x_connec" DROP CONSTRAINT IF EXISTS "rtc_hydrometer_x_connec_hydrometer_id_fkey";
ALTER TABLE "rtc_hydrometer_x_connec" DROP CONSTRAINT IF EXISTS "rtc_hydrometer_x_connec_connec_id_fkey";

ALTER TABLE "ext_rtc_hydrometer_x_value" DROP CONSTRAINT IF EXISTS "ext_rtc_hydrometer_x_value_hydrometer_id_fkey";
ALTER TABLE "ext_rtc_hydrometer_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_hydrometer_x_data_hydrometer_id_fkey";


--ADD

ALTER TABLE "rtc_scada_node" ADD CONSTRAINT "rtc_scada_node_scada_id_fkey" FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_scada_node" ADD CONSTRAINT "rtc_scada_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "rtc_scada_x_dma" ADD CONSTRAINT "rtc_scada_x_dma_scada_id_fkey" FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_scada_x_dma" ADD CONSTRAINT "rtc_scada_x_dma_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "rtc_scada_x_sector" ADD CONSTRAINT "rtc_scada_x_sector_scada_id_fkey" FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_scada_x_sector" ADD CONSTRAINT "rtc_scada_x_sector_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "rtc_hydrometer_x_connec" ADD CONSTRAINT "rtc_hydrometer_x_connec_hydrometer_id_fkey" FOREIGN KEY ("hydrometer_id") REFERENCES "rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_hydrometer_x_connec" ADD CONSTRAINT "rtc_hydrometer_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

