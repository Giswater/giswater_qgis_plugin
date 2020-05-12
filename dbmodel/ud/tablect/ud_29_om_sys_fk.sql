/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE "om_visit_x_gully" DROP CONSTRAINT IF EXISTS "om_visit_x_gully_visit_id_fkey";
ALTER TABLE "om_visit_x_gully" DROP CONSTRAINT IF EXISTS "om_visit_x_gully_gully_id_fkey";

--ADD
ALTER TABLE "om_visit_x_gully" ADD CONSTRAINT "om_visit_x_gully_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_gully" ADD CONSTRAINT "om_visit_x_gully_gully_id_fkey" FOREIGN KEY ("gully_id") REFERENCES "gully" ("gully_id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "om_visit_event"  ADD CONSTRAINT "om_visit_event_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "node" ("node_id") ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "om_visit_x_node" ADD CONSTRAINT "om_visit_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_arc" ADD CONSTRAINT "om_visit_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_connec" ADD CONSTRAINT "om_visit_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_psector_x_arc" ADD CONSTRAINT "om_psector_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector_x_node" ADD CONSTRAINT "om_psector_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
