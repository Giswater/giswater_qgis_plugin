/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-----
-- MAIN (ARC-NODE)
-----

-----
-- connec-link
-----
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("connecat_id") REFERENCES "SCHEMA_NAME"."cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."link" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;


-----
-- dma
-----
ALTER TABLE "SCHEMA_NAME"."dma" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."connec" ADD FOREIGN KEY ("dma_id") REFERENCES "SCHEMA_NAME"."dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ----------------------------
-- cat_soil
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("soilcat_id") REFERENCES "SCHEMA_NAME"."cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-- ----------------------------
-- cat_manager
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("manager") REFERENCES "SCHEMA_NAME"."manager" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("manager") REFERENCES "SCHEMA_NAME"."manager" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-- ----------------------------
-- cat_builder
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("buildercat_id") REFERENCES "SCHEMA_NAME"."cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ----------------------------
-- cat_work
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("workcat_id") REFERENCES "SCHEMA_NAME"."cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- ----------------------------
-- type_category
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("category_type") REFERENCES "SCHEMA_NAME"."man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-- ----------------------------
-- type_fluid
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("fluid_type") REFERENCES "SCHEMA_NAME"."man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;




-- ----------------------------
-- type_location
-- ----------------------------
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("location_type") REFERENCES "SCHEMA_NAME"."man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-----
-- DERIVADED (ARC-NODE)
-----

ALTER TABLE "SCHEMA_NAME"."man_arc_conduit" ADD FOREIGN KEY ("func_type") REFERENCES "SCHEMA_NAME"."man_type_function" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_arc_conduit" ADD FOREIGN KEY ("hydrocat_id") REFERENCES "SCHEMA_NAME"."cat_man_hydrometer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_arc_conduit" ADD FOREIGN KEY ("flapcat_id") REFERENCES "SCHEMA_NAME"."cat_man_flap" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."man_node_mhole" ADD FOREIGN KEY ("covercat_id") REFERENCES "SCHEMA_NAME"."cat_man_cover" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_node_mhole" ADD FOREIGN KEY ("stepcat_id") REFERENCES "SCHEMA_NAME"."cat_man_step" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."man_node_mhole" ADD FOREIGN KEY ("stepcat_id2") REFERENCES "SCHEMA_NAME"."cat_man_step" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
