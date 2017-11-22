/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP RULE IF EXISTS insert_plan_arc_x_pavement ON arc;
--CREATE OR REPLACE RULE insert_plan_arc_x_pavement AS ON INSERT TO arc DO INSERT INTO plan_arc_x_pavement (arc_id,percent) VALUES (NEW.arc_id, '1');