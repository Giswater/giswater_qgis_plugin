/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_visit_id_fkey";
ALTER TABLE "om_visit_event" ADD FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_parameter_id_fkey";
ALTER TABLE "om_visit_event" ADD FOREIGN KEY ("parameter_id") REFERENCES "om_visit_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_position_id_fkey";
ALTER TABLE "om_visit_event" ADD FOREIGN KEY ("position_id") REFERENCES "om_visit_value_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_visit_parameter" DROP CONSTRAINT IF EXISTS "om_visit_parameter_parameter_type_fkey";
ALTER TABLE "om_visit_parameter" ADD FOREIGN KEY ("parameter_type") REFERENCES "om_visit_parameter_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_node" DROP CONSTRAINT IF EXISTS "om_visit_x_node_visit_id_fkey";
ALTER TABLE "om_visit_x_node" ADD FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_node" DROP CONSTRAINT IF EXISTS "om_visit_x_node_node_id_fkey";
ALTER TABLE "om_visit_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_arc" DROP CONSTRAINT IF EXISTS "om_visit_x_arc_visit_id_fkey";
ALTER TABLE "om_visit_x_arc" ADD FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_arc" DROP CONSTRAINT IF EXISTS "om_visit_x_arc_arc_id_fkey";
ALTER TABLE "om_visit_x_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_connec" DROP CONSTRAINT IF EXISTS "om_visit_x_connec_visit_id_fkey";
ALTER TABLE "om_visit_x_connec" ADD FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_connec" DROP CONSTRAINT IF EXISTS "om_visit_x_connec_connec_id_fkey";
ALTER TABLE "om_visit_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
