/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




ALTER TABLE "SCHEMA_NAME"."event" ADD FOREIGN KEY ("event_type") REFERENCES "SCHEMA_NAME"."event_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_parameter" ADD FOREIGN KEY ("event_type") REFERENCES "SCHEMA_NAME"."event_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_node" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_node" ADD FOREIGN KEY ("parameter_id") REFERENCES "SCHEMA_NAME"."event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_node" ADD FOREIGN KEY ("position_id") REFERENCES "SCHEMA_NAME"."event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_arc" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_arc" ADD FOREIGN KEY ("parameter_id") REFERENCES "SCHEMA_NAME"."event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_arc" ADD FOREIGN KEY ("position_id") REFERENCES "SCHEMA_NAME"."event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_element" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_element" ADD FOREIGN KEY ("element_id") REFERENCES "SCHEMA_NAME"."element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_element" ADD FOREIGN KEY ("parameter_id") REFERENCES "SCHEMA_NAME"."event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_element" ADD FOREIGN KEY ("position_id") REFERENCES "SCHEMA_NAME"."event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("parameter_id") REFERENCES "SCHEMA_NAME"."event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_connec" ADD FOREIGN KEY ("position_id") REFERENCES "SCHEMA_NAME"."event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("gully_id") REFERENCES "SCHEMA_NAME"."gully" ("gully_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("parameter_id") REFERENCES "SCHEMA_NAME"."event_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."event_x_gully" ADD FOREIGN KEY ("position_id") REFERENCES "SCHEMA_NAME"."event_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
