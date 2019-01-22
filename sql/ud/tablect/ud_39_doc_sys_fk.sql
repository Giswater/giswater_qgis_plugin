/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


--DROP
ALTER TABLE "doc_x_gully" DROP CONSTRAINT IF EXISTS "doc_x_gully_doc_id_fkey";
ALTER TABLE "doc_x_gully" DROP CONSTRAINT IF EXISTS "doc_x_gully_gully_id_fkey";

--ADD
ALTER TABLE "doc_x_gully" ADD CONSTRAINT "doc_x_gully_doc_id_fkey" FOREIGN KEY ("doc_id") REFERENCES "doc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "doc_x_gully" ADD CONSTRAINT "doc_x_gully_gully_id_fkey" FOREIGN KEY ("gully_id") REFERENCES "gully" ("gully_id") ON DELETE RESTRICT ON UPDATE CASCADE;


