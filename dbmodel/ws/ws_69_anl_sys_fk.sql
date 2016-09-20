/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- MINCUT
-- ----------------------------

ALTER TABLE "anl_mincut_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_valve" ADD FOREIGN KEY ("valve_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;


-- ----------------------------
-- MINCUT CATALOG
-- ----------------------------

ALTER TABLE "anl_mincut_result_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_valve" ADD FOREIGN KEY ("valve_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_hydrometer" ADD FOREIGN KEY ("hydrometer_id") REFERENCES "ext_rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "anl_mincut_result_polygon" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_node" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_arc" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_connec" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_valve" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_hydrometer" ADD FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "anl_mincut_result_selector" ADD FOREIGN KEY ("id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_selector_compare" ADD FOREIGN KEY ("id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
