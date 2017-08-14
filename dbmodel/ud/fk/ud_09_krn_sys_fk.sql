/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;
/*)

------
-- FK 01
------

ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_featurecat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_type_id_fkey";

ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_gratecat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_arccat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_matcat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_groove_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_siphon_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_featurecat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_dma_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_soilcat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_category_type_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_fluid_type_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_location_type_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_workcat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_workcat_id_end_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_buildercat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_ownercat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_streetaxis_id_fkey";

ALTER TABLE "man_junction" DROP CONSTRAINT IF EXISTS "man_junction_node_id_fkey";
ALTER TABLE "man_storage" DROP CONSTRAINT IF EXISTS "man_storage_node_id_fkey";
ALTER TABLE "man_outfall" DROP CONSTRAINT IF EXISTS "man_outfall_node_id_fkey";
ALTER TABLE "man_netgully" DROP CONSTRAINT IF EXISTS "man_netgully_node_id_fkey";
ALTER TABLE "man_valve" DROP CONSTRAINT IF EXISTS "man_valve_node_id_fkey";
ALTER TABLE "man_chamber" DROP CONSTRAINT IF EXISTS "man_chamber_node_id_fkey";
ALTER TABLE "man_manhole" DROP CONSTRAINT IF EXISTS "man_manhole_node_id_fkey";
ALTER TABLE "man_netinit" DROP CONSTRAINT IF EXISTS "man_netinit_node_id_fkey";
ALTER TABLE "man_wjump" DROP CONSTRAINT IF EXISTS "man_wjump_node_id_fkey";
ALTER TABLE "man_wwtp" DROP CONSTRAINT IF EXISTS "man_wwtp_node_id_fkey";

ALTER TABLE "man_conduit" DROP CONSTRAINT IF EXISTS "man_conduit_arc_id_fkey";
ALTER TABLE "man_varc" DROP CONSTRAINT IF EXISTS "man_varc_arc_id_fkey";
ALTER TABLE "man_siphon" DROP CONSTRAINT IF EXISTS "man_siphon_arc_id_fkey";
ALTER TABLE "man_waccel" DROP CONSTRAINT IF EXISTS "man_waccel_arc_id_fkey";

ALTER TABLE "element_x_gully" DROP CONSTRAINT IF EXISTS "element_x_gully_element_id_fkey";
ALTER TABLE "element_x_gully" DROP CONSTRAINT IF EXISTS "element_x_gully_gully_id_fkey";







-- 
--CREATE FK
---



ALTER TABLE "node" ADD CONSTRAINT "node_node_type_fkey" FOREIGN KEY ("node_type") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "arc" ADD CONSTRAINT "arc_arc_type_fkey" FOREIGN KEY ("arc_type") REFERENCES "arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" ADD CONSTRAINT "connec_featurecat_id_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_type_id_fkey" FOREIGN KEY ("connec_type") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_gratecat_id_fkey" FOREIGN KEY ("gratecat_id") REFERENCES "cat_grate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_arccat_id_fkey" FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_groove_fkey" FOREIGN KEY ("groove") REFERENCES "value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_siphon_fkey" FOREIGN KEY ("siphon") REFERENCES "value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_featurecat_id_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" ADD CONSTRAINT "gully_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "man_junction" ADD CONSTRAINT "man_junction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_storage" ADD CONSTRAINT "man_storage_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_outfall" ADD CONSTRAINT "man_outfall_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netgully" ADD CONSTRAINT "man_netgully_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" ADD CONSTRAINT "man_valve_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_chamber" ADD CONSTRAINT "man_chamber_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_manhole" ADD CONSTRAINT "man_manhole_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netinit" ADD CONSTRAINT "man_netinit_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_wjump" ADD CONSTRAINT "man_wjump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_wwtp" ADD CONSTRAINT "man_wwtp_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_conduit" ADD CONSTRAINT "man_conduit_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_varc" ADD CONSTRAINT "man_varc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_siphon" ADD CONSTRAINT "man_siphon_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_waccel" ADD CONSTRAINT "man_waccel_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "element_x_gully" ADD CONSTRAINT "element_x_gully_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element_x_gully" ADD CONSTRAINT "element_x_gully_gully_id_fkey" FOREIGN KEY ("gully_id") REFERENCES "gully" ("gully_id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE gully ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES ext_streetaxis (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


--ALTER TABLE arc  ADD CONSTRAINT arc_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE node  ADD CONSTRAINT node_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE connec  ADD CONSTRAINT connec_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE gully ADD CONSTRAINT gully_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma_selector (macrodma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


*/

