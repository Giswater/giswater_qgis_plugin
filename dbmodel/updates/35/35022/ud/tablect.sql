/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/02/25
ALTER TABLE inp_lidcontrol_value ADD CONSTRAINT inp_lidcontrol_lidco_id_fkey FOREIGN KEY (lidco_id)
REFERENCES inp_lidcontrol (lidco_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
