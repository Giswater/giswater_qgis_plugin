/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE "man_selector_state" DROP CONSTRAINT IF EXISTS "man_selector_state_id_fkey";
ALTER TABLE "man_selector_state" ADD CONSTRAINT "man_selector_state_id_fkey" FOREIGN KEY ("id") REFERENCES value_state (id) ON UPDATE CASCADE ON DELETE CASCADE;

