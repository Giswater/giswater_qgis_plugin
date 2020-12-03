/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
/*
--DROP
ALTER TABLE "anl_node" DROP CONSTRAINT IF EXISTS "anl_node_node_id_fkey";
ALTER TABLE "anl_node" DROP CONSTRAINT IF EXISTS "anl_node_state_fkey";
ALTER TABLE "anl_node" DROP CONSTRAINT IF EXISTS "anl_node_expl_fkey";
ALTER TABLE "anl_node" DROP CONSTRAINT IF EXISTS "anl_node_fprocesscat_id_fkey";

ALTER TABLE "anl_connec" DROP CONSTRAINT IF EXISTS "anl_connec_connec_id_fkey";
ALTER TABLE "anl_connec" DROP CONSTRAINT IF EXISTS "anl_connec_state_fkey";
ALTER TABLE "anl_connec" DROP CONSTRAINT IF EXISTS "anl_connec_expl_fkey";
ALTER TABLE "anl_connec" DROP CONSTRAINT IF EXISTS "anl_connec_fprocesscat_id_fkey";

ALTER TABLE "anl_arc" DROP CONSTRAINT IF EXISTS "anl_arc_arc_id_fkey";
ALTER TABLE "anl_arc" DROP CONSTRAINT IF EXISTS "anl_arc_state_fkey";
ALTER TABLE "anl_arc" DROP CONSTRAINT IF EXISTS "anl_arc_fkey";
ALTER TABLE "anl_arc" DROP CONSTRAINT IF EXISTS "anl_arc_fprocesscat_id_fkey";

ALTER TABLE "anl_arc_x_node" DROP CONSTRAINT IF EXISTS "anl_arc_x_node_arc_id_fkey";
ALTER TABLE "anl_arc_x_node" DROP CONSTRAINT IF EXISTS "anl_arc_x_node_node_id_fkey";
ALTER TABLE "anl_arc_x_node" DROP CONSTRAINT IF EXISTS "anl_arc_x_node_state_fkey";
ALTER TABLE "anl_arc_x_node" DROP CONSTRAINT IF EXISTS "anl_arc_x_node_fkey";
ALTER TABLE "anl_arc_x_node" DROP CONSTRAINT IF EXISTS "anl_arc_x_node_fprocesscat_id_fkey";

--ADD
ALTER TABLE "anl_node" ADD CONSTRAINT "anl_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_node" ADD CONSTRAINT "anl_node_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_node" ADD CONSTRAINT "anl_node_expl_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_node" ADD CONSTRAINT "anl_node_fprocesscat_id_fkey" FOREIGN KEY ("fprocesscat_id")  REFERENCES "sys_fprocess_cat" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "anl_connec" ADD CONSTRAINT "anl_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_connec" ADD CONSTRAINT "anl_connec_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_connec" ADD CONSTRAINT "anl_connec_expl_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_connec" ADD CONSTRAINT "anl_connec_fprocesscat_id_fkey" FOREIGN KEY ("fprocesscat_id")  REFERENCES "sys_fprocess_cat" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "anl_arc" ADD CONSTRAINT "anl_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_arc" ADD CONSTRAINT "anl_arc_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_arc" ADD CONSTRAINT "anl_arc_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_arc" ADD CONSTRAINT "anl_arc_fprocesscat_id_fkey" FOREIGN KEY ("fprocesscat_id")  REFERENCES "sys_fprocess_cat" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "anl_arc_x_node" ADD CONSTRAINT "anl_arc_x_node_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_arc_x_node" ADD CONSTRAINT "anl_arc_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_arc_x_node" ADD CONSTRAINT "anl_arc_x_node_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_arc_x_node" ADD CONSTRAINT "anl_arc_x_node_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "anl_arc_x_node" ADD CONSTRAINT "anl_arc_x_node_fprocesscat_id_fkey" FOREIGN KEY ("fprocesscat_id")  REFERENCES "sys_fprocess_cat" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

*/
