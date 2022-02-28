/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/02/25
ALTER TABLE inp_lid_value ADD CONSTRAINT inp_lid_lidco_id_fkey FOREIGN KEY (lidco_id)
REFERENCES inp_lid (lidco_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_lid_usage ADD CONSTRAINT inp_dscenario_lid_usage_lidco_id_fkey FOREIGN KEY (lidco_id)
REFERENCES inp_lid (lidco_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
