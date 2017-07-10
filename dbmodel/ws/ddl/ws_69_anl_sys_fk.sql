/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- MINCUT
-- ----------------------------
ALTER TABLE "anl_mincut_node" DROP CONSTRAINT IF EXISTS "anl_mincut_node_node_id_fkey";
ALTER TABLE "anl_mincut_arc" DROP CONSTRAINT IF EXISTS "anl_mincut_arc_arc_id_fkey";
ALTER TABLE "anl_mincut_valve" DROP CONSTRAINT IF EXISTS "anl_mincut_valve_valve_id_fkey";

ALTER TABLE "anl_mincut_node" ADD CONSTRAINT "anl_mincut_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_arc" ADD CONSTRAINT "anl_mincut_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_valve" ADD CONSTRAINT "anl_mincut_valve_valve_id_fkey" FOREIGN KEY ("valve_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;


-- ----------------------------
-- MINCUT CATALOG
-- ----------------------------
ALTER TABLE "anl_mincut_result_node" DROP CONSTRAINT IF EXISTS "anl_mincut_result_node_node_id_fkey";
ALTER TABLE "anl_mincut_result_arc" DROP CONSTRAINT IF EXISTS "anl_mincut_result_arc_arc_id_fkey";
ALTER TABLE "anl_mincut_result_connec" DROP CONSTRAINT IF EXISTS "anl_mincut_result_connec_connec_id_fkey";
ALTER TABLE "anl_mincut_result_valve" DROP CONSTRAINT IF EXISTS "anl_mincut_result_valve_valve_id_fkey";
ALTER TABLE "anl_mincut_result_hydrometer" DROP CONSTRAINT IF EXISTS "anl_mincut_result_hydrometer_hydrometer_id_fkey";
ALTER TABLE "anl_mincut_result_polygon" DROP CONSTRAINT IF EXISTS "anl_mincut_result_polygon_mincut_result_cat_id_fkey";
ALTER TABLE "anl_mincut_result_node" DROP CONSTRAINT IF EXISTS "anl_mincut_result_node_mincut_result_cat_id_fkey";
ALTER TABLE "anl_mincut_result_arc" DROP CONSTRAINT IF EXISTS "anl_mincut_result_arc_mincut_result_cat_id_fkey";
ALTER TABLE "anl_mincut_result_connec" DROP CONSTRAINT IF EXISTS "anl_mincut_result_connec_mincut_result_cat_id_fkey";
ALTER TABLE "anl_mincut_result_valve" DROP CONSTRAINT IF EXISTS "anl_mincut_result_valve_mincut_result_cat_id_fkey";
ALTER TABLE "anl_mincut_result_hydrometer" DROP CONSTRAINT IF EXISTS "anl_mincut_result_hydrometer_mincut_result_cat_id_fkey";

ALTER TABLE "anl_mincut_result_selector" DROP CONSTRAINT IF EXISTS "anl_mincut_result_selector_id_fkey";
ALTER TABLE "anl_mincut_result_selector_compare" DROP CONSTRAINT IF EXISTS "anl_mincut_result_selector_compare_id_fkey";


ALTER TABLE "anl_mincut_result_node" ADD CONSTRAINT "anl_mincut_result_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_arc" ADD CONSTRAINT "anl_mincut_result_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_connec" ADD CONSTRAINT "anl_mincut_result_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_valve" ADD CONSTRAINT "anl_mincut_result_valve_valve_id_fkey" FOREIGN KEY ("valve_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "anl_mincut_result_polygon" ADD CONSTRAINT "anl_mincut_result_polygon_mincut_result_cat_id_fkey" FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_node" ADD CONSTRAINT "anl_mincut_result_node_mincut_result_cat_id_fkey" FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_arc" ADD CONSTRAINT "anl_mincut_result_arc_mincut_result_cat_id_fkey" FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_connec" ADD CONSTRAINT "anl_mincut_result_connec_mincut_result_cat_id_fkey" FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_valve" ADD CONSTRAINT "anl_mincut_result_valve_mincut_result_cat_id_fkey" FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_hydrometer" ADD CONSTRAINT "anl_mincut_result_hydrometer_mincut_result_cat_id_fkey" FOREIGN KEY ("mincut_result_cat_id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "anl_mincut_result_selector" ADD CONSTRAINT "anl_mincut_result_selector_id_fkey" FOREIGN KEY ("id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_mincut_result_selector_compare" ADD CONSTRAINT "anl_mincut_result_selector_compare_id_fkey" FOREIGN KEY ("id") REFERENCES "anl_mincut_result_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

