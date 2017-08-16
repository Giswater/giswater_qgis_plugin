/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


------
-- FK 01
------
/*
--ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_presszonecat_id_fkey";

ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_arctype_id_fkey";

ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_nodetype_id_fkey";


ALTER TABLE "man_junction" DROP CONSTRAINT IF EXISTS "man_junction_node_id_fkey";
ALTER TABLE "man_tank" DROP CONSTRAINT IF EXISTS "man_tank_node_id_fkey";
ALTER TABLE "man_hydrant" DROP CONSTRAINT IF EXISTS "man_hydrant_node_id_fkey";
ALTER TABLE "man_valve" DROP CONSTRAINT IF EXISTS "man_valve_node_id_fkey";
ALTER TABLE "man_pump" DROP CONSTRAINT IF EXISTS "man_pump_node_id_fkey";
ALTER TABLE "man_meter" DROP CONSTRAINT IF EXISTS "man_meter_node_id_fkey";
ALTER TABLE "man_filter" DROP CONSTRAINT IF EXISTS "man_filter_node_id_fkey";
ALTER TABLE "man_reduction" DROP CONSTRAINT IF EXISTS "man_reduction_node_id_fkey";
ALTER TABLE "man_source" DROP CONSTRAINT IF EXISTS "man_source_node_id_fkey";
ALTER TABLE "man_waterwell" DROP CONSTRAINT IF EXISTS "man_waterwell_node_id_fkey";
ALTER TABLE "man_manhole" DROP CONSTRAINT IF EXISTS "man_manhole_node_id_fkey";

ALTER TABLE "man_pipe" DROP CONSTRAINT IF EXISTS "man_pipe_arc_id_fkey";

ALTER TABLE "man_fountain" DROP CONSTRAINT IF EXISTS "man_fountain_connec_id_fkey";
ALTER TABLE "man_greentap" DROP CONSTRAINT IF EXISTS "man_greentap_connec_id_fkey";
ALTER TABLE "man_tap" DROP CONSTRAINT IF EXISTS "man_tap_connec_id_fkey";
ALTER TABLE "man_wjoin" DROP CONSTRAINT IF EXISTS "man_wjoin_connec_id_fkey";

	

--ALTER TABLE "presszone" DROP CONSTRAINT IF EXISTS "presszone_presszonecat_id_fkey";

ALTER TABLE "pond" DROP CONSTRAINT IF EXISTS "pond_connec_id_fkey";
ALTER TABLE "pool" DROP CONSTRAINT IF EXISTS "pool_connec_id_fkey";

ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_workcat_id_fkey";
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_workcat_id_end_fkey";


ALTER TABLE man_register DROP CONSTRAINT IF EXISTS "man_register_fkey";
ALTER TABLE man_netwjoin DROP CONSTRAINT IF EXISTS "man_netwjoin_fkey";
ALTER TABLE man_expansiontank DROP CONSTRAINT IF EXISTS "man_expansiontank_fkey";
ALTER TABLE man_flexunion DROP CONSTRAINT IF EXISTS "man_flexunion_fkey";

ALTER TABLE man_varc DROP CONSTRAINT IF EXISTS "man_varc_fkey";

ALTER TABLE pond DROP CONSTRAINT IF EXISTS "pond_state_fkey";

ALTER TABLE pool DROP CONSTRAINT IF EXISTS "pool_state_fkey";


--ALTER TABLE man_valve DROP CONSTRAINT IF EXISTS "cat_node_cat_valve2_fkey";
--ALTER TABLE man_tap DROP CONSTRAINT IF EXISTS "cat_node_cat_valve2_fkey";
--ALTER TABLE man_wjoin DROP CONSTRAINT IF EXISTS "cat_node_cat_valve2_fkey";
ALTER TABLE man_fountain DROP CONSTRAINT IF EXISTS "connec_linked_connec_fkey";
ALTER TABLE man_tap DROP CONSTRAINT IF EXISTS "connec_linked_connec_fkey";
ALTER TABLE man_greentap DROP CONSTRAINT IF EXISTS "connec_linked_connec_fkey";


ALTER TABLE pond DROP CONSTRAINT IF EXISTS "pond_dma_id_fkey";
ALTER TABLE pool DROP CONSTRAINT IF EXISTS "pool_dma_id_fkey";
ALTER TABLE samplepoint DROP CONSTRAINT IF EXISTS "samplepoint_dma_id_fkey";





-- 
--CREATE FK
---

--ALTER TABLE "dma" ADD CONSTRAINT "dma_presszonecat_id_fkey" FOREIGN KEY ("presszonecat_id") REFERENCES "cat_presszone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_arctype_id_fkey" FOREIGN KEY ("arctype_id") REFERENCES "arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_nodetype_id_fkey" FOREIGN KEY ("nodetype_id") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "man_junction" ADD CONSTRAINT "man_junction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_tank" ADD CONSTRAINT "man_tank_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_hydrant" ADD CONSTRAINT "man_hydrant_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" ADD CONSTRAINT "man_valve_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_pump" ADD CONSTRAINT "man_pump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_meter" ADD CONSTRAINT "man_meter_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_filter" ADD CONSTRAINT "man_filter_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE  "man_reduction" ADD CONSTRAINT "man_reduction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_source" ADD CONSTRAINT "man_source_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_waterwell" ADD CONSTRAINT "man_waterwell_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_manhole" ADD CONSTRAINT "man_manhole_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "man_pipe" ADD CONSTRAINT "man_pipe_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_fountain" ADD CONSTRAINT "man_fountain_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_greentap" ADD CONSTRAINT "man_greentap_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_tap" ADD CONSTRAINT "man_tap_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_wjoin" ADD CONSTRAINT "man_wjoin_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
	

--ALTER TABLE "presszone" ADD CONSTRAINT "presszone_presszonecat_id_fkey" FOREIGN KEY ("presszonecat_id") REFERENCES "cat_press_zone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "pond" ADD CONSTRAINT "pond_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pool" ADD CONSTRAINT "pool_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE man_register ADD CONSTRAINT man_register_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netwjoin ADD CONSTRAINT man_netwjoin_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_expansiontank ADD CONSTRAINT man_expansiontank_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_flexunion ADD CONSTRAINT man_flexunion_fkey FOREIGN KEY (node_id) REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE man_varc ADD CONSTRAINT man_varc_fkey FOREIGN KEY (arc_id) REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE pond DROP CONSTRAINT IF EXISTS "pond_state_fkey";
ALTER TABLE pond ADD CONSTRAINT pond_state_fkey FOREIGN KEY (state)  REFERENCES value_state (id) MATCH SIMPLE  ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE pool DROP CONSTRAINT IF EXISTS "pool_state_fkey";
ALTER TABLE pool ADD CONSTRAINT pool_state_fkey FOREIGN KEY (state)  REFERENCES value_state (id) MATCH SIMPLE  ON UPDATE CASCADE ON DELETE RESTRICT;
  

--ALTER TABLE man_valve  ADD CONSTRAINT cat_node_cat_valve2_fkey FOREIGN KEY (cat_valve2) REFERENCES cat_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE man_tap  ADD CONSTRAINT cat_node_cat_valve2_fkey FOREIGN KEY (cat_valve2) REFERENCES cat_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
--ALTER TABLE man_wjoin  ADD CONSTRAINT cat_node_cat_valve2_fkey FOREIGN KEY (cat_valve2) REFERENCES cat_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_fountain  ADD CONSTRAINT connec_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_tap  ADD CONSTRAINT connec_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_greentap  ADD CONSTRAINT connec_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;



ALTER TABLE pond  ADD CONSTRAINT pond_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma (dma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE pool  ADD CONSTRAINT pool_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma (dma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint  ADD CONSTRAINT samplepoint_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;*/
