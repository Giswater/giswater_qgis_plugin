/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Fk 61
-- ----------------------------
--DROP
ALTER TABLE "anl_flow_node" DROP CONSTRAINT IF EXISTS "anl_flow_node_node_id_fkey";
ALTER TABLE "anl_flow_node" DROP CONSTRAINT IF EXISTS "anl_flow_node_exploitation_id_fkey";

ALTER TABLE "anl_flow_arc" DROP CONSTRAINT IF EXISTS "anl_flow_arc_arc_id_fkey";
ALTER TABLE "anl_flow_arc" DROP CONSTRAINT IF EXISTS "anl_flow_arc_exploitation_id_fkey";

ALTER TABLE "anl_arc_profile_value" DROP CONSTRAINT IF EXISTS "anl_arc_profile_value_arc_id_fkey";

--ADD

ALTER TABLE "anl_flow_node" ADD CONSTRAINT "anl_flow_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_flow_node" ADD CONSTRAINT "anl_flow_node_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "anl_flow_arc" ADD CONSTRAINT "anl_flow_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_flow_arc" ADD CONSTRAINT "anl_flow_arc_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "anl_arc_profile_value" ADD CONSTRAINT "anl_arc_profile_value_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
