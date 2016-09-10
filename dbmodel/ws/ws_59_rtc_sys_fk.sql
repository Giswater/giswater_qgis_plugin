/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Fk 51
-- ----------------------------

ALTER TABLE "rtc_scada_node" ADD FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_scada_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "rtc_scada_x_dma" ADD FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_scada_x_dma" ADD FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "rtc_scada_x_sector" ADD FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_scada_x_sector" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "rtc_hydrometer_x_connec" ADD FOREIGN KEY ("hydrometer_id") REFERENCES "ext_rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_hydrometer_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rtc_options" ADD FOREIGN KEY ("period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_options" ADD FOREIGN KEY ("rtc_status") REFERENCES "rtc_value_opti_status" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "rtc_options" ADD FOREIGN KEY ("coefficient") REFERENCES "rtc_value_opti_coef" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
