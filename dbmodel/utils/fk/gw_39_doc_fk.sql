/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Fk 31
-- ----------------------------
--DROP
ALTER TABLE "doc" DROP CONSTRAINT IF EXISTS "doc_doc_type_fkey";
ALTER TABLE "doc_x_node" DROP CONSTRAINT IF EXISTS "doc_x_node_doc_id_fkey";
ALTER TABLE "doc_x_node" DROP CONSTRAINT IF EXISTS "doc_x_node_node_id_fkey";

ALTER TABLE "doc_x_arc" DROP CONSTRAINT IF EXISTS "doc_x_arc_doc_id_fkey";
ALTER TABLE "doc_x_arc" DROP CONSTRAINT IF EXISTS "doc_x_arc_arc_id_fkey";

ALTER TABLE "doc_x_connec" DROP CONSTRAINT IF EXISTS "doc_x_connec_doc_id_fkey";
ALTER TABLE "doc_x_connec" DROP CONSTRAINT IF EXISTS "doc_x_connec_connec_id_fkey";

ALTER TABLE "doc_x_visit" DROP CONSTRAINT IF EXISTS "doc_x_visit_doc_id_fkey";
ALTER TABLE "doc_x_visit" DROP CONSTRAINT IF EXISTS "doc_x_visit_visit_id_fkey";


--ADD
ALTER TABLE "doc" ADD CONSTRAINT "doc_doc_type_fkey" FOREIGN KEY ("doc_type") REFERENCES "doc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "doc_x_node" ADD CONSTRAINT "doc_x_node_doc_id_fkey" FOREIGN KEY ("doc_id") REFERENCES "doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "doc_x_node" ADD CONSTRAINT "doc_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "doc_x_arc" ADD CONSTRAINT "doc_x_arc_doc_id_fkey" FOREIGN KEY ("doc_id") REFERENCES "doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "doc_x_arc" ADD CONSTRAINT "doc_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "doc_x_connec" ADD CONSTRAINT "doc_x_connec_doc_id_fkey" FOREIGN KEY ("doc_id") REFERENCES "doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "doc_x_connec" ADD CONSTRAINT "doc_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "doc_x_visit" ADD CONSTRAINT "doc_x_visit_doc_id_fkey" FOREIGN KEY ("doc_id") REFERENCES "doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "doc_x_visit" ADD CONSTRAINT "doc_x_visit_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
