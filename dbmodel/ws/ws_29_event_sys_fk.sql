/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Fk 21
-- ----------------------------


ALTER TABLE "event" ADD FOREIGN KEY ("event_type") REFERENCES "event_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "event_parameter" ADD FOREIGN KEY ("event_type") REFERENCES "event_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "event_x_node" ADD FOREIGN KEY ("event_id") REFERENCES "event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_node" ADD FOREIGN KEY ("parameter_id") REFERENCES "event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_node" ADD FOREIGN KEY ("position_id") REFERENCES "event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "event_x_arc" ADD FOREIGN KEY ("event_id") REFERENCES "event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_arc" ADD FOREIGN KEY ("parameter_id") REFERENCES "event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_arc" ADD FOREIGN KEY ("position_id") REFERENCES "event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "event_x_element" ADD FOREIGN KEY ("event_id") REFERENCES "event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_element" ADD FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_element" ADD FOREIGN KEY ("parameter_id") REFERENCES "event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_element" ADD FOREIGN KEY ("position_id") REFERENCES "event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "event_x_connec" ADD FOREIGN KEY ("event_id") REFERENCES "event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_connec" ADD FOREIGN KEY ("parameter_id") REFERENCES "event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "event_x_connec" ADD FOREIGN KEY ("position_id") REFERENCES "event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


