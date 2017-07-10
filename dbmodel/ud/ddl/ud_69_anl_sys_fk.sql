/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Fk 61
-- ----------------------------

ALTER TABLE "anl_flow_trace_node" DROP CONSTRAINT IF EXISTS "anl_flow_trace_node_node_id_fkey";
ALTER TABLE "anl_flow_trace_arc" DROP CONSTRAINT IF EXISTS "anl_flow_trace_arc_arc_id_fkey";

ALTER TABLE "anl_flow_exit_node" DROP CONSTRAINT IF EXISTS "anl_flow_exit_node_node_id_fkey";
ALTER TABLE "anl_flow_exit_arc" DROP CONSTRAINT IF EXISTS "anl_flow_exit_arc_arc_id_fkey";



ALTER TABLE "anl_flow_trace_node" ADD CONSTRAINT "anl_flow_trace_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_flow_trace_arc" ADD CONSTRAINT "anl_flow_trace_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "anl_flow_exit_node" ADD CONSTRAINT "anl_flow_exit_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_flow_exit_arc" ADD CONSTRAINT "anl_flow_exit_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
