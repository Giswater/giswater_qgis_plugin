/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP CHECK

ALTER TABLE "value_state" DROP CONSTRAINT IF EXISTS "value_state_check";
ALTER TABLE "man_addfields_cat_datatype" DROP CONSTRAINT IF EXISTS "man_addfields_cat_datatype_check";
ALTER TABLE "man_addfields_cat_widgettype" DROP CONSTRAINT IF EXISTS "man_addfields_cat_widgettype_check";

-- ADD CHECK

ALTER TABLE "value_state" ADD CONSTRAINT value_state_check CHECK (id IN (0,1,2));

/*
-- PER REVISAR
ALTER TABLE SCHEMA_NAME.man_addfields_cat_datatype ADD CONSTRAINT man_addfields_cat_datatype_check CHECK (id IN ());
ALTER TABLE SCHEMA_NAME.man_addfields_cat_widgettype ADD CONSTRAINT man_addfields_cat_widgettype_check CHECK (id IN ());
*/