/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


ALTER TABLE "SCHEMA_NAME"."doc" ADD FOREIGN KEY ("doc_type") REFERENCES "SCHEMA_NAME"."doc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."doc" ADD FOREIGN KEY ("tagcat_id") REFERENCES "SCHEMA_NAME"."cat_tag" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."doc_x_node" ADD FOREIGN KEY ("doc_id") REFERENCES "SCHEMA_NAME"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."doc_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."doc_x_arc" ADD FOREIGN KEY ("doc_id") REFERENCES "SCHEMA_NAME"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."doc_x_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."doc_x_connec" ADD FOREIGN KEY ("doc_id") REFERENCES "SCHEMA_NAME"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."doc_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "SCHEMA_NAME"."connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."doc_x_gully" ADD FOREIGN KEY ("doc_id") REFERENCES "SCHEMA_NAME"."doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."doc_x_gully" ADD FOREIGN KEY ("gully_id") REFERENCES "SCHEMA_NAME"."gully" ("gully_id") ON DELETE RESTRICT ON UPDATE CASCADE;
